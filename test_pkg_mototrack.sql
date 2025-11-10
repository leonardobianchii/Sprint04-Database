SET SERVEROUTPUT ON;
-- chamados diretos
BEGIN
  pkg_mototrack.prc_aluguel_em_json(1);
  pkg_mototrack.prc_resumo_km_por_filial_modelo;
END;
/

SELECT pkg_mototrack.fn_validar_senha_complexidade(NULL)  AS teste1 FROM dual;
SELECT pkg_mototrack.fn_validar_senha_complexidade('Abcdef1!') AS teste2 FROM dual;
