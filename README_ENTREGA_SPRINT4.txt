
Arquivos gerados:
- dataset_alugueis.json
- mongo_mototrack_import.js
- pkg_mototrack.sql
- test_pkg_mototrack.sql
- DemoProcedures.java
- prints PNG (print_aluguel_json.png, print_resumo_km.png, print_senha.png, print_auditoria.png)
- modelagem_relacional.pdf

MongoDB (opção 1 - mongo shell):
mongo < mongo_mototrack_import.js

MongoDB (opção 2 - mongoimport):
mongoimport --db mototrack --collection alugueis --file dataset_alugueis.json --jsonArray

Oracle:
@pkg_mototrack.sql
@test_pkg_mototrack.sql
