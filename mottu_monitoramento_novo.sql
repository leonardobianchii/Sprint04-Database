SET SERVEROUTPUT ON;

CREATE TABLE T_CM_PAIS (
  id_pais NUMBER(8) PRIMARY KEY,
  nm_pais VARCHAR2(50) NOT NULL
);

CREATE TABLE T_CM_ESTADO (
  id_estado NUMBER(8) PRIMARY KEY,
  id_pais NUMBER(8) REFERENCES T_CM_PAIS(id_pais),
  nm_estado VARCHAR2(50) NOT NULL
);

CREATE TABLE T_CM_CIDADE (
  id_cidade NUMBER(8) PRIMARY KEY,
  id_estado NUMBER(8) REFERENCES T_CM_ESTADO(id_estado),
  nm_cidade VARCHAR2(50) NOT NULL
);

CREATE TABLE T_CM_BAIRRO (
  id_bairro NUMBER(8) PRIMARY KEY,
  id_cidade NUMBER(8) REFERENCES T_CM_CIDADE(id_cidade),
  nm_bairro VARCHAR2(100) NOT NULL
);


CREATE TABLE T_CM_LOGRADOURO (
  id_logradouro NUMBER(8) PRIMARY KEY,
  id_bairro NUMBER(8) REFERENCES T_CM_BAIRRO(id_bairro),
  nm_logradouro VARCHAR2(100) NOT NULL,
  nr_logradouro VARCHAR2(10) NOT NULL,
  nm_complemento VARCHAR2(100)
);

CREATE TABLE T_CM_CLIENTE (
  id_cliente NUMBER(8) PRIMARY KEY,
  id_logradouro NUMBER(8) REFERENCES T_CM_LOGRADOURO(id_logradouro),
  nm_cliente VARCHAR2(100) NOT NULL,
  nr_cpf VARCHAR2(14) UNIQUE NOT NULL,
  nm_email VARCHAR2(100) UNIQUE NOT NULL
);

-- Tabela: T_CM_MODELO 
CREATE TABLE T_CM_MODELO (
  id_modelo NUMBER(8) PRIMARY KEY,
  nm_modelo VARCHAR2(100) NOT NULL
);

-- Tabela: T_CM_FILIAL_DEPARTAMENTO 
CREATE TABLE T_CM_FILIAL_DEPARTAMENTO (
  id_filial_departamento NUMBER(8) PRIMARY KEY,
  nm_filial_departamento VARCHAR2(100) NOT NULL
);

-- Tabela: T_CM_MOTO
CREATE TABLE T_CM_MOTO (
  id_moto NUMBER(8) PRIMARY KEY,
  id_modelo NUMBER(8) NOT NULL,
  id_filial_departamento NUMBER(8) NOT NULL,
  nm_placa VARCHAR2(10) NOT NULL UNIQUE,
  st_moto VARCHAR2(30),
  km_rodado NUMBER(9),
  CONSTRAINT fk_moto_modelo FOREIGN KEY (id_modelo) REFERENCES T_CM_MODELO(id_modelo),
  CONSTRAINT fk_moto_filial FOREIGN KEY (id_filial_departamento) REFERENCES T_CM_FILIAL_DEPARTAMENTO(id_filial_departamento)
);

-- Tabela: T_CM_ALUGUEL 
CREATE TABLE T_CM_ALUGUEL (
  id_aluguel NUMBER(8) PRIMARY KEY,
  id_cliente NUMBER(8) NOT NULL,
  id_moto NUMBER(8) NOT NULL,
  dt_retirada TIMESTAMP NOT NULL,
  dt_devolucao TIMESTAMP,
  CONSTRAINT fk_aluguel_cliente FOREIGN KEY (id_cliente) REFERENCES T_CM_CLIENTE(id_cliente),
  CONSTRAINT fk_aluguel_moto FOREIGN KEY (id_moto) REFERENCES T_CM_MOTO(id_moto)
);

-- Tabela: T_CM_POSICAO_MOTO 
CREATE TABLE T_CM_POSICAO_MOTO (
  id_posicao NUMBER(8) PRIMARY KEY,
  id_filial_departamento NUMBER(8) NOT NULL,
  nr_x NUMBER(8,2) NOT NULL,
  nr_y NUMBER(8,2) NOT NULL,
  nm_setor VARCHAR2(50),
  dt_posicao TIMESTAMP,
  CONSTRAINT fk_posicao_filial FOREIGN KEY (id_filial_departamento) REFERENCES T_CM_FILIAL_DEPARTAMENTO(id_filial_departamento)
);

-- Tabela: T_CM_MANUTENCAO
CREATE TABLE T_CM_MANUTENCAO (
  id_manutencao NUMBER(8) PRIMARY KEY,
  id_moto NUMBER(8) NOT NULL,
  dt_entrada TIMESTAMP NOT NULL,
  dt_saida TIMESTAMP,
  ds_manutencao VARCHAR2(300),
  CONSTRAINT fk_manutencao_moto FOREIGN KEY (id_moto) REFERENCES T_CM_MOTO(id_moto)
);

-- Tabela: T_CM_IMAGEM_REGISTRO
CREATE TABLE T_CM_IMAGEM_REGISTRO (
  id_imagem_registro NUMBER(8) PRIMARY KEY,
  id_posicao NUMBER(8) NOT NULL,
  dt_imagem TIMESTAMP NOT NULL,
  nm_caminho_arquivo VARCHAR2(255) NOT NULL,
  CONSTRAINT fk_imagem_posicao FOREIGN KEY (id_posicao) REFERENCES T_CM_POSICAO_MOTO(id_posicao)
);

-- Tabela: T_CM_SENSOR_RFID
CREATE TABLE T_CM_SENSOR_RFID (
  id_sensor NUMBER(8) PRIMARY KEY,
  nm_sensor VARCHAR2(100) NOT NULL,
  id_filial_departamento NUMBER(8) NOT NULL,
  nm_localizacao VARCHAR2(100),
  CONSTRAINT fk_sensor_filial FOREIGN KEY (id_filial_departamento) REFERENCES T_CM_FILIAL_DEPARTAMENTO(id_filial_departamento)
);

-- Tabela: T_CM_LOCALIZACAO_MOTO_RFID
CREATE TABLE T_CM_LOCALIZACAO_MOTO_RFID (
  id_localizacao NUMBER(8) PRIMARY KEY,
  id_moto NUMBER(8) NOT NULL,
  id_sensor NUMBER(8) NOT NULL,
  dt_localizacao TIMESTAMP NOT NULL,
  CONSTRAINT fk_localizacao_moto FOREIGN KEY (id_moto) REFERENCES T_CM_MOTO(id_moto),
  CONSTRAINT fk_localizacao_sensor FOREIGN KEY (id_sensor) REFERENCES T_CM_SENSOR_RFID(id_sensor)
);



INSERT INTO T_CM_PAIS (id_pais, nm_pais) VALUES (1, 'Brasil');
INSERT INTO T_CM_PAIS (id_pais, nm_pais) VALUES (2, 'Mexico');
INSERT INTO T_CM_PAIS (id_pais, nm_pais) VALUES (3, 'Argentina');
INSERT INTO T_CM_PAIS (id_pais, nm_pais) VALUES (4, 'Colombia');
INSERT INTO T_CM_PAIS (id_pais, nm_pais) VALUES (5, 'Chile');


INSERT INTO T_CM_ESTADO (id_estado, id_pais, nm_estado) VALUES (1, 1, 'São Paulo');
INSERT INTO T_CM_ESTADO (id_estado, id_pais, nm_estado) VALUES (2, 1, 'Rio de Janeiro');
INSERT INTO T_CM_ESTADO (id_estado, id_pais, nm_estado) VALUES (3, 2, 'Ciudad de México');
INSERT INTO T_CM_ESTADO (id_estado, id_pais, nm_estado) VALUES (4, 3, 'Buenos Aires');
INSERT INTO T_CM_ESTADO (id_estado, id_pais, nm_estado) VALUES (5, 4, 'Bogotá');
INSERT INTO T_CM_ESTADO (id_estado, id_pais, nm_estado) VALUES (6, 5, 'Santiago');

INSERT INTO T_CM_CIDADE (id_cidade, id_estado, nm_cidade) VALUES (1, 1, 'São Paulo');
INSERT INTO T_CM_CIDADE (id_cidade, id_estado, nm_cidade) VALUES (2, 1, 'Campinas');
INSERT INTO T_CM_CIDADE (id_cidade, id_estado, nm_cidade) VALUES (3, 2, 'Rio de Janeiro');
INSERT INTO T_CM_CIDADE (id_cidade, id_estado, nm_cidade) VALUES (4, 3, 'Ciudad de México');
INSERT INTO T_CM_CIDADE (id_cidade, id_estado, nm_cidade) VALUES (5, 4, 'Buenos Aires');


INSERT INTO T_CM_BAIRRO (id_bairro, id_cidade, nm_bairro) VALUES (1, 1, 'Centro');
INSERT INTO T_CM_BAIRRO (id_bairro, id_cidade, nm_bairro) VALUES (2, 2, 'Jardim São José');
INSERT INTO T_CM_BAIRRO (id_bairro, id_cidade, nm_bairro) VALUES (3, 3, 'Copacabana');
INSERT INTO T_CM_BAIRRO (id_bairro, id_cidade, nm_bairro) VALUES (4, 4, 'Polanco');
INSERT INTO T_CM_BAIRRO (id_bairro, id_cidade, nm_bairro) VALUES (5, 5, 'Palermo');

INSERT INTO T_CM_LOGRADOURO (id_logradouro, id_bairro, nm_logradouro, nr_logradouro, nm_complemento) 
VALUES (1, 1, 'Avenida Paulista', '1000', 'Proximo ao MASP');
INSERT INTO T_CM_LOGRADOURO (id_logradouro, id_bairro, nm_logradouro, nr_logradouro, nm_complemento) 
VALUES (2, 2, 'Rua dos Tres Irmãos', '250', 'Proximo ao mercado');
INSERT INTO T_CM_LOGRADOURO (id_logradouro, id_bairro, nm_logradouro, nr_logradouro, nm_complemento) 
VALUES (3, 3, 'Avenida Atlantica', '500', 'Proximo a praia');
INSERT INTO T_CM_LOGRADOURO (id_logradouro, id_bairro, nm_logradouro, nr_logradouro, nm_complemento) 
VALUES (4, 4, 'Avenida Reforma', '2000', 'Proximo ao museu');
INSERT INTO T_CM_LOGRADOURO (id_logradouro, id_bairro, nm_logradouro, nr_logradouro, nm_complemento) 
VALUES (5, 5, 'Rua Niceto Vega', '300', 'Proximo ao parque');


INSERT INTO T_CM_CLIENTE (id_cliente, id_logradouro, nm_cliente, nr_cpf, nm_email)
VALUES (1, 1, 'Carlos Silva', '123.456.789-00', 'carlos.silva@email.com');
INSERT INTO T_CM_CLIENTE (id_cliente, id_logradouro, nm_cliente, nr_cpf, nm_email)
VALUES (2, 2, 'Ana Costa', '987.654.321-00', 'ana.costa@email.com');
INSERT INTO T_CM_CLIENTE (id_cliente, id_logradouro, nm_cliente, nr_cpf, nm_email)
VALUES (3, 3, 'João Pereira', '111.222.333-44', 'joao.pereira@email.com');
INSERT INTO T_CM_CLIENTE (id_cliente, id_logradouro, nm_cliente, nr_cpf, nm_email)
VALUES (4, 4, 'Mariana Alves', '555.666.777-88', 'mariana.alves@email.com');
INSERT INTO T_CM_CLIENTE (id_cliente, id_logradouro, nm_cliente, nr_cpf, nm_email)
VALUES (5, 5, 'Ricardo Gomes', '999.000.111-22', 'ricardo.gomes@email.com');


INSERT INTO T_CM_MODELO (id_modelo, nm_modelo) VALUES (1, 'Honda CG 160');
INSERT INTO T_CM_MODELO (id_modelo, nm_modelo) VALUES (2, 'Yamaha Factor 150');
INSERT INTO T_CM_MODELO (id_modelo, nm_modelo) VALUES (3, 'Honda CB 500');
INSERT INTO T_CM_MODELO (id_modelo, nm_modelo) VALUES (4, 'Yamaha MT-07');
INSERT INTO T_CM_MODELO (id_modelo, nm_modelo) VALUES (5, 'Honda Biz 125');


INSERT INTO T_CM_FILIAL_DEPARTAMENTO (id_filial_departamento, nm_filial_departamento) VALUES (1, 'Filial São Paulo');
INSERT INTO T_CM_FILIAL_DEPARTAMENTO (id_filial_departamento, nm_filial_departamento) VALUES (2, 'Filial Rio de Janeiro');
INSERT INTO T_CM_FILIAL_DEPARTAMENTO (id_filial_departamento, nm_filial_departamento) VALUES (3, 'Filial Campinas');
INSERT INTO T_CM_FILIAL_DEPARTAMENTO (id_filial_departamento, nm_filial_departamento) VALUES (4, 'Filial Belo Horizonte');
INSERT INTO T_CM_FILIAL_DEPARTAMENTO (id_filial_departamento, nm_filial_departamento) VALUES (5, 'Filial Curitiba');


INSERT INTO T_CM_MOTO (id_moto, id_modelo, id_filial_departamento, nm_placa, st_moto, km_rodado) 
VALUES (1, 1, 1, 'ABC-1234', 'Disponivel', 15000);
INSERT INTO T_CM_MOTO (id_moto, id_modelo, id_filial_departamento, nm_placa, st_moto, km_rodado) 
VALUES (2, 2, 2, 'XYZ-5678', 'Em manutencao', 8000);
INSERT INTO T_CM_MOTO (id_moto, id_modelo, id_filial_departamento, nm_placa, st_moto, km_rodado) 
VALUES (3, 3, 3, 'DEF-4321', 'Disponivel', 12000);
INSERT INTO T_CM_MOTO (id_moto, id_modelo, id_filial_departamento, nm_placa, st_moto, km_rodado) 
VALUES (4, 4, 4, 'GHI-8765', 'Em manutencao', 5000);
INSERT INTO T_CM_MOTO (id_moto, id_modelo, id_filial_departamento, nm_placa, st_moto, km_rodado) 
VALUES (5, 5, 5, 'JKL-1357', 'Disponível', 7000);


INSERT INTO T_CM_ALUGUEL (id_aluguel, id_cliente, id_moto, dt_retirada, dt_devolucao)VALUES (1, 1, 1, TO_TIMESTAMP('2025-05-12 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO T_CM_ALUGUEL (id_aluguel, id_cliente, id_moto, dt_retirada, dt_devolucao)VALUES (2, 2, 2, TO_TIMESTAMP('2025-05-10 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO T_CM_ALUGUEL (id_aluguel, id_cliente, id_moto, dt_retirada, dt_devolucao)VALUES (3, 3, 3, TO_TIMESTAMP('2025-05-11 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO T_CM_ALUGUEL (id_aluguel, id_cliente, id_moto, dt_retirada, dt_devolucao)VALUES (4, 4, 4, TO_TIMESTAMP('2025-05-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO T_CM_ALUGUEL (id_aluguel, id_cliente, id_moto, dt_retirada, dt_devolucao)VALUES (5, 5, 5, TO_TIMESTAMP('2025-05-12 12:00:00','YYYY-MM-DD HH24:MI:SS'), NULL);


INSERT INTO T_CM_POSICAO_MOTO (id_posicao, id_filial_departamento, nr_x, nr_y, nm_setor, dt_posicao) 
VALUES (1, 1, 10.1234, 20.5678, 'Setor A', TO_TIMESTAMP('2025-05-12 08:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO T_CM_POSICAO_MOTO (id_posicao, id_filial_departamento, nr_x, nr_y, nm_setor, dt_posicao) 
VALUES (2, 2, 30.9876, 50.2345, 'Setor B', TO_TIMESTAMP('2025-05-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO T_CM_POSICAO_MOTO (id_posicao, id_filial_departamento, nr_x, nr_y, nm_setor, dt_posicao) 
VALUES (3, 3, 15.5678, 25.1234, 'Setor C', TO_TIMESTAMP('2025-05-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO T_CM_POSICAO_MOTO (id_posicao, id_filial_departamento, nr_x, nr_y, nm_setor, dt_posicao) 
VALUES (4, 4, 40.2345, 55.9876, 'Setor D', TO_TIMESTAMP('2025-05-12 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));


INSERT INTO T_CM_MANUTENCAO (id_manutencao, id_moto, dt_entrada, dt_saida, ds_manutencao) 
VALUES (1, 2, TO_TIMESTAMP('2025-05-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Troca de Oleo e revisao geral');
INSERT INTO T_CM_MANUTENCAO (id_manutencao, id_moto, dt_entrada, dt_saida, ds_manutencao) 
VALUES (2, 4, TO_TIMESTAMP('2025-05-08 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-10 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Troca de pneus');
INSERT INTO T_CM_MANUTENCAO (id_manutencao, id_moto, dt_entrada, dt_saida, ds_manutencao) 
VALUES (4, 3, TO_TIMESTAMP('2025-05-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Troca de Oleo');
INSERT INTO T_CM_MANUTENCAO (id_manutencao, id_moto, dt_entrada, dt_saida, ds_manutencao) 
VALUES (5, 1, TO_TIMESTAMP('2025-04-29 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-04-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Ajuste do freio');



INSERT INTO T_CM_SENSOR_RFID (id_sensor, nm_sensor, id_filial_departamento, nm_localizacao)
VALUES (1, 'Sensor A', 1, 'Entrada principal');
INSERT INTO T_CM_SENSOR_RFID (id_sensor, nm_sensor, id_filial_departamento, nm_localizacao)
VALUES (2, 'Sensor B', 2, 'P�tio secund�rio');
INSERT INTO T_CM_SENSOR_RFID (id_sensor, nm_sensor, id_filial_departamento, nm_localizacao)
VALUES (3, 'Sensor C', 3, 'Entrada lateral');
INSERT INTO T_CM_SENSOR_RFID (id_sensor, nm_sensor, id_filial_departamento, nm_localizacao)
VALUES (4, 'Sensor D', 4, 'P�tio principal');
INSERT INTO T_CM_SENSOR_RFID (id_sensor, nm_sensor, id_filial_departamento, nm_localizacao)
VALUES (5, 'Sensor E', 5, 'Garagem 2');


INSERT INTO T_CM_LOCALIZACAO_MOTO_RFID (id_localizacao, id_moto, id_sensor, dt_localizacao) 
VALUES (1, 1, 1, TO_TIMESTAMP('2025-05-12 08:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO T_CM_LOCALIZACAO_MOTO_RFID (id_localizacao, id_moto, id_sensor, dt_localizacao) 
VALUES (2, 2, 2, TO_TIMESTAMP('2025-05-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO T_CM_LOCALIZACAO_MOTO_RFID (id_localizacao, id_moto, id_sensor, dt_localizacao) 
VALUES (3, 3, 3, TO_TIMESTAMP('2025-05-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO T_CM_LOCALIZACAO_MOTO_RFID (id_localizacao, id_moto, id_sensor, dt_localizacao) 
VALUES (4, 4, 4, TO_TIMESTAMP('2025-05-12 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));


--------------------------------------------------------------------------------
-- Função 01: Relacional -> JSON (manual, sem JSON_*), com 3+ exceções
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_ALUGUEL_JSON (p_id_aluguel IN NUMBER)
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
                '"retirada":"' || TO_CHAR(v_dt_retirada,'YYYY-MM-DD"T"HH24:MI:SS') || '",'||
                '"devolucao":' || CASE WHEN v_dt_devolucao IS NULL THEN 'null'
                                       ELSE '"'||TO_CHAR(v_dt_devolucao,'YYYY-MM-DD"T"HH24:MI:SS')||'"' END ||
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
/

--------------------------------------------------------------------------------
-- Procedure 01: JOIN + exibição do JSON (chama a Função 01), 3+ exceções
--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_ALUGUEL_EM_JSON (p_id_aluguel IN NUMBER) IS
  v_json CLOB;
BEGIN
  IF p_id_aluguel IS NULL THEN RAISE VALUE_ERROR; END IF;
  v_json := FN_ALUGUEL_JSON(p_id_aluguel);
  DBMS_OUTPUT.PUT_LINE(v_json);
EXCEPTION
  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('{"erro":"Parâmetro inválido (VALUE_ERROR)"}');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('{"erro":"Falha inesperada em PRC_ALUGUEL_EM_JSON: '||
                         REPLACE(REPLACE(SQLERRM,'\','\\'),'"','''')||
                         '","codigo":'||SQLCODE||'}');
END;
/

--------------------------------------------------------------------------------
-- Procedure 02: Somatórios manuais Kilometragem (Filial, Modelo) + Subtotal + Total Geral
--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_RESUMO_KM_POR_FILIAL_MODELO IS
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
/

--------------------------------------------------------------------------------
-- Função 02: Validação de senha (processo lógico), com 3+ exceções
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_VALIDAR_SENHA_COMPLEXIDADE(p_senha IN VARCHAR2)
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
/

--------------------------------------------------------------------------------
-- Auditoria DML: tabela e trigger de auditoria em T_CM_ALUGUEL
--------------------------------------------------------------------------------

CREATE TABLE T_AUDITORIA_DML (
  id_auditoria NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  nm_tabela    VARCHAR2(60)  NOT NULL,
  nm_usuario   VARCHAR2(128) NOT NULL,
  tp_operacao  VARCHAR2(10)  NOT NULL,
  dt_evento    TIMESTAMP     DEFAULT SYSTIMESTAMP,
  ds_old       CLOB,
  ds_new       CLOB
);

CREATE OR REPLACE TRIGGER TRG_AUD_T_CM_ALUGUEL
AFTER INSERT OR UPDATE OR DELETE ON T_CM_ALUGUEL
FOR EACH ROW
DECLARE
  v_json_old CLOB;
  v_json_new CLOB;
  v_op VARCHAR2(10);

  FUNCTION JNUM(n NUMBER) RETURN VARCHAR2 IS
  BEGIN RETURN CASE WHEN n IS NULL THEN 'null' ELSE TO_CHAR(n) END; END;
  FUNCTION JTS(t TIMESTAMP) RETURN VARCHAR2 IS
  BEGIN RETURN CASE WHEN t IS NULL THEN 'null' ELSE '"'||TO_CHAR(t,'YYYY-MM-DD"T"HH24:MI:SS')||'"' END; END;
BEGIN
  IF INSERTING THEN v_op := 'INSERT';
  ELSIF UPDATING THEN v_op := 'UPDATE';
  ELSE v_op := 'DELETE'; END IF;

  IF NOT INSERTING THEN
    v_json_old := '{'||'"id_aluguel":'||JNUM(:OLD.id_aluguel)||','||
                        '"id_cliente":'||JNUM(:OLD.id_cliente)||','||
                        '"id_moto":'||JNUM(:OLD.id_moto)||','||
                        '"dt_retirada":'||JTS(:OLD.dt_retirada)||','||
                        '"dt_devolucao":'||JTS(:OLD.dt_devolucao)||'}';
  END IF;

  IF NOT DELETING THEN
    v_json_new := '{'||'"id_aluguel":'||JNUM(:NEW.id_aluguel)||','||
                        '"id_cliente":'||JNUM(:NEW.id_cliente)||','||
                        '"id_moto":'||JNUM(:NEW.id_moto)||','||
                        '"dt_retirada":'||JTS(:NEW.dt_retirada)||','||
                        '"dt_devolucao":'||JTS(:NEW.dt_devolucao)||'}';
  END IF;

  INSERT INTO T_AUDITORIA_DML (nm_tabela,nm_usuario,tp_operacao,dt_evento,ds_old,ds_new)
  VALUES ('T_CM_ALUGUEL', SYS_CONTEXT('USERENV','SESSION_USER'), v_op, SYSTIMESTAMP, v_json_old, v_json_new);
END;
/

--------------------------------------------------------------------------------
-- Bloco de testes
--------------------------------------------------------------------------------

-- Função 01 + Procedure 01
BEGIN
  PRC_ALUGUEL_EM_JSON(1);       -- OK
  PRC_ALUGUEL_EM_JSON(9999);    -- erro tratado
END;
/

-- Procedure 02
BEGIN
  PRC_RESUMO_KM_POR_FILIAL_MODELO;
END;
/

-- Função 02
SELECT FN_VALIDAR_SENHA_COMPLEXIDADE(NULL)       AS teste1 FROM dual;  -- erro tratado
SELECT FN_VALIDAR_SENHA_COMPLEXIDADE('Abcdef1!') AS teste2 FROM dual;  -- OK


--------------------------------------------------------------------------------
-- -- Trigger de auditoria (INSERT / UPDATE / DELETE)
--------------------------------------------------------------------------------

INSERT INTO T_CM_ALUGUEL (id_aluguel,id_cliente,id_moto,dt_retirada,dt_devolucao)
VALUES (9001,1,1,SYSTIMESTAMP,NULL);
UPDATE T_CM_ALUGUEL SET dt_devolucao = SYSTIMESTAMP + INTERVAL '1' HOUR WHERE id_aluguel=9001;
DELETE FROM T_CM_ALUGUEL WHERE id_aluguel=9001;
COMMIT;

SELECT id_auditoria, nm_tabela, nm_usuario, tp_operacao,
       TO_CHAR(dt_evento,'YYYY-MM-DD HH24:MI:SS') AS dt_evento,
       DBMS_LOB.SUBSTR(ds_old,32767,1) AS old_json,
       DBMS_LOB.SUBSTR(ds_new,32767,1) AS new_json
  FROM T_AUDITORIA_DML
 WHERE nm_tabela='T_CM_ALUGUEL'
 ORDER BY id_auditoria;
 