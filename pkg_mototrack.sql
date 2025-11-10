SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE pkg_mototrack AS
  FUNCTION fn_aluguel_json(p_id_aluguel IN NUMBER) RETURN CLOB;
  PROCEDURE prc_aluguel_em_json(p_id_aluguel IN NUMBER);
  PROCEDURE prc_resumo_km_por_filial_modelo;
  FUNCTION fn_validar_senha_complexidade(p_senha IN VARCHAR2) RETURN VARCHAR2;
END pkg_mototrack;
/

CREATE OR REPLACE PACKAGE BODY pkg_mototrack AS

  FUNCTION fn_aluguel_json(p_id_aluguel IN NUMBER)
  RETURN CLOB
  IS
    v_json   CLOB;
    v_id_aluguel   NUMBER(8);
    v_id_cliente   NUMBER(8);
    v_nm_cliente   VARCHAR2(100);
    v_id_moto      NUMBER(8);
    v_nm_placa     VARCHAR2(10);
    v_id_modelo    NUMBER(8);
    v_nm_modelo    VARCHAR2(100);
    v_id_filial    NUMBER(8);
    v_nm_filial    VARCHAR2(100);
    v_dt_retirada  TIMESTAMP;
    v_dt_devolucao TIMESTAMP;

    FUNCTION esc(p IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
      IF p IS NULL THEN RETURN NULL; END IF;
      RETURN REPLACE(REPLACE(p,'\','\\'),'"','\"');
    END;
  BEGIN
    IF p_id_aluguel IS NULL THEN RAISE VALUE_ERROR; END IF;

    SELECT a.id_aluguel, c.id_cliente, c.nm_cliente,
           m.id_moto, m.nm_placa,
           mo.id_modelo, mo.nm_modelo,
           f.id_filial_departamento, f.nm_filial_departamento,
           a.dt_retirada, a.dt_devolucao
      INTO v_id_aluguel, v_id_cliente, v_nm_cliente,
           v_id_moto, v_nm_placa,
           v_id_modelo, v_nm_modelo,
           v_id_filial, v_nm_filial,
           v_dt_retirada, v_dt_devolucao
      FROM T_CM_ALUGUEL a
      JOIN T_CM_CLIENTE c ON c.id_cliente = a.id_cliente
      JOIN T_CM_MOTO    m ON m.id_moto    = a.id_moto
      JOIN T_CM_MODELO  mo ON mo.id_modelo = m.id_modelo
      JOIN T_CM_FILIAL_DEPARTAMENTO f ON f.id_filial_departamento = m.id_filial_departamento
     WHERE a.id_aluguel = p_id_aluguel;

    v_json := '{'||
                '"id_aluguel":'||v_id_aluguel||','||
                '"periodo":{'||
                  '"retirada":"' || TO_CHAR(v_dt_retirada,'YYYY-MM-DD""T""HH24:MI:SS') || '",'||
                  '"devolucao":' || CASE WHEN v_dt_devolucao IS NULL THEN 'null'
                                         ELSE '"'||TO_CHAR(v_dt_devolucao,'YYYY-MM-DD""T""HH24:MI:SS')||'"' END ||
                '},'||
                '"cliente":{"id":'||v_id_cliente||',"nome":"'||esc(v_nm_cliente)||'"},'||
                '"moto":{"id":'||v_id_moto||',"placa":"'||esc(v_nm_placa)||'"},'||
                '"modelo":{"id":'||v_id_modelo||',"nome":"'||esc(v_nm_modelo)||'"},'||
                '"filial":{"id":'||v_id_filial||',"nome":"'||esc(v_nm_filial)||'"}'||
              '}';

    RETURN v_json;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN '{"erro":"Aluguel não encontrado (ID inexistente)"}';
    WHEN TOO_MANY_ROWS THEN
      RETURN '{"erro":"Mais de um registro encontrado para o aluguel informado"}';
    WHEN VALUE_ERROR THEN
      RETURN '{"erro":"Parâmetro inválido (VALUE_ERROR)"}';
    WHEN OTHERS THEN
      RETURN '{"erro":"Falha inesperada em FN_ALUGUEL_JSON: '||
              REPLACE(REPLACE(SQLERRM,'\','\\'),'"','''')||
              '","codigo":'||SQLCODE||'}';
  END;

  PROCEDURE prc_aluguel_em_json (p_id_aluguel IN NUMBER) IS
    v_json CLOB;
  BEGIN
    IF p_id_aluguel IS NULL THEN RAISE VALUE_ERROR; END IF;
    v_json := fn_aluguel_json(p_id_aluguel);
    DBMS_OUTPUT.PUT_LINE(v_json);
  EXCEPTION
    WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE('{"erro":"Parâmetro inválido (VALUE_ERROR)"}');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('{"erro":"Falha inesperada em PRC_ALUGUEL_EM_JSON: '||
                           REPLACE(REPLACE(SQLERRM,'\','\\'),'"','''')||
                           '","codigo":'||SQLCODE||'}');
  END;

  PROCEDURE prc_resumo_km_por_filial_modelo IS
    CURSOR c_detalhe IS
      SELECT f.nm_filial_departamento AS filial,
             mo.nm_modelo             AS modelo,
             NVL(m.km_rodado,0)       AS km_rodado
        FROM T_CM_MOTO m
        JOIN T_CM_FILIAL_DEPARTAMENTO f ON f.id_filial_departamento = m.id_filial_departamento
        JOIN T_CM_MODELO mo ON mo.id_modelo = m.id_modelo
       ORDER BY f.nm_filial_departamento, mo.nm_modelo;

    v_filial_atual VARCHAR2(100) := NULL;
    v_subtotal     NUMBER := 0;
    v_total        NUMBER := 0;
    v_linhas       PLS_INTEGER := 0;

    PROCEDURE print_linha(p_filial VARCHAR2, p_modelo VARCHAR2, p_km NUMBER) IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE(
        RPAD(NVL(p_filial,' '),24)||' | '||
        RPAD(NVL(p_modelo,' '),18)||' | '||
        TO_CHAR(p_km,'FM999G999G999D00')
      );
    END;
  BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Filial',24)||' | '||RPAD('Modelo',18)||' | Km Somado');
    DBMS_OUTPUT.PUT_LINE(RPAD('-',24,'-')||'-+-'||RPAD('-',18,'-')||'-+-'||RPAD('-',12,'-'));

    FOR r IN c_detalhe LOOP
      v_linhas := v_linhas + 1;
      IF r.km_rodado < 0 THEN RAISE VALUE_ERROR; END IF;

      IF v_filial_atual IS NOT NULL AND r.filial <> v_filial_atual THEN
        print_linha('Sub Total', NULL, v_subtotal);
        v_subtotal := 0;
      END IF;

      print_linha(r.filial, r.modelo, r.km_rodado);
      v_subtotal := v_subtotal + r.km_rodado;
      v_total    := v_total    + r.km_rodado;
      v_filial_atual := r.filial;
    END LOOP;

    IF v_linhas = 0 THEN
      RAISE NO_DATA_FOUND;
    ELSE
      print_linha('Sub Total', NULL, v_subtotal);
      print_linha('Total Geral', NULL, v_total);
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Nenhum dado encontrado (verifique ≥ 5 motos).');
    WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE('Erro de validação: km_rodado inválido.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Falha inesperada em PRC_RESUMO_KM_POR_FILIAL_MODELO: '||
                           REPLACE(REPLACE(SQLERRM,'\','\\'),'"','''')||
                           ' (código '||SQLCODE||')');
  END;

  FUNCTION fn_validar_senha_complexidade(p_senha IN VARCHAR2)
  RETURN VARCHAR2
  IS
  BEGIN
    IF p_senha IS NULL THEN RAISE VALUE_ERROR; END IF;
    IF LENGTH(p_senha) < 8 THEN RETURN 'ERRO: Mínimo de 8 caracteres'; END IF;
    IF NOT REGEXP_LIKE(p_senha,'[[:upper:]]') THEN RETURN 'ERRO: Inclua ao menos 1 letra maiúscula'; END IF;
    IF NOT REGEXP_LIKE(p_senha,'[[:lower:]]') THEN RETURN 'ERRO: Inclua ao menos 1 letra minúscula'; END IF;
    IF NOT REGEXP_LIKE(p_senha,'[[:digit:]]') THEN RETURN 'ERRO: Inclua ao menos 1 dígito'; END IF;
    IF NOT REGEXP_LIKE(p_senha,'[^[:alnum:]]') THEN RETURN 'ERRO: Inclua ao menos 1 caractere especial'; END IF;
    RETURN 'OK';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 'ERRO: Senha não informada (NO_DATA_FOUND)';
    WHEN VALUE_ERROR THEN   RETURN 'ERRO: Senha nula ou inválida (VALUE_ERROR)';
    WHEN OTHERS THEN        RETURN 'ERRO: Falha inesperada em FN_VALIDAR_SENHA_COMPLEXIDADE: '||
                                     REPLACE(REPLACE(SQLERRM,'\','\\'),'"','''')||
                                     ' (código '||SQLCODE||')';
  END;

END pkg_mototrack;
/

-- Trigger de auditoria permanece standalone (não empacotável)
