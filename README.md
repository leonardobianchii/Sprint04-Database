# 🏍️ MotoTrack - Sprint 4  
**Mastering Relational and Non-Relational Databases**

## 📘 Descrição do Projeto
O **MotoTrack** é um sistema de monitoramento e gerenciamento de motos voltado para controle de **alugueis, manutenções e rastreamento**, integrando tecnologias **relacionais (Oracle)** e **não relacionais (MongoDB)**.  
Este repositório contém a entrega da **4ª Sprint**, que aborda empacotamento de rotinas PL/SQL, integração com backend Java e exportação de dados para um banco NoSQL.

---

## 👥 Integrantes
| Nome | RM |
|------|----|
| Cauã Sanches de Santana | RM558317 |
| Leonardo Bianchi | RM558576 |
| Angello Turano | RM556511 |

---

## 🧩 Estrutura do Repositório

```
📦 MotoTrack-Sprint4
├── 📁 sql
│   ├── pkg_mototrack.sql              # Pacote PL/SQL com procedures, funções e tratamento de exceções
│   ├── test_pkg_mototrack.sql         # Script de testes do pacote
│   └── modelagem_relacional.pdf       # Modelo lógico e físico (diagramas)
│
├── 📁 mongo
│   ├── dataset_alugueis.json          # Dataset exportado do banco relacional
│   └── mongo_mototrack_import.js      # Script para criação/importação no MongoDB
│
├── 📁 java
│   └── DemoProcedures.java            # Classe Java para integração via JDBC (Oracle)
│
├── 📁 prints
│   ├── print_aluguel_json.png         # Execução da procedure PRC_ALUGUEL_EM_JSON
│   ├── print_resumo_km.png            # Execução da procedure PRC_RESUMO_KM_POR_FILIAL_MODELO
│   ├── print_senha.png                # Execução da função FN_VALIDAR_SENHA_COMPLEXIDADE
│   └── print_auditoria.png            # Trigger de auditoria em funcionamento
│
└── README.md                          # Documento principal (este arquivo)
```

---

## ⚙️ Banco de Dados Relacional (Oracle)

### 📦 Empacotamento
Foi criado o **pacote PL/SQL `pkg_mototrack`**, contendo:

- `fn_aluguel_json` – Gera um registro em formato JSON para um aluguel específico  
- `prc_aluguel_em_json` – Exibe o JSON completo de um aluguel  
- `prc_resumo_km_por_filial_modelo` – Gera um resumo do KM rodado por filial e modelo  
- `fn_validar_senha_complexidade` – Valida senha conforme regras de segurança  

As rotinas estão organizadas em módulos, com **tratamento de exceções** e boas práticas de PL/SQL.  
A **trigger de auditoria** permanece independente, registrando todas as operações DML (INSERT, UPDATE, DELETE).

---

### ▶️ Execução (Oracle SQL Developer)

1. Conecte-se ao banco Oracle.  
2. Execute os scripts:
   ```sql
   @pkg_mototrack.sql
   @test_pkg_mototrack.sql
   ```
3. Observe as saídas no painel de **DBMS Output**, conforme prints.

---

## 🍃 Banco de Dados Não Relacional (MongoDB)

Os dados exportados do Oracle foram estruturados em formato JSON para inserção no MongoDB.

### 🗃️ Estrutura de Coleções
- `alugueis`
- `motos`
- `modelos`
- `filiais`
- `clientes`

### 🔧 Importação

#### Opção 1 – via `mongo` shell:
```bash
mongo < mongo_mototrack_import.js
```

#### Opção 2 – via `mongoimport`:
```bash
mongoimport --db mototrack --collection alugueis --file dataset_alugueis.json --jsonArray
```

As coleções são criadas automaticamente com índices para **cliente**, **moto** e **período de retirada**.

---

## ☕ Integração Java

A integração com o Oracle foi feita por meio da classe `DemoProcedures.java`, utilizando **JDBC**.

### Exemplo de execução:
```java
CallableStatement cs = cn.prepareCall("{ call pkg_mototrack.prc_aluguel_em_json(?) }");
cs.setInt(1, 1);
cs.execute();
```

### Saídas esperadas:
- Retorno em formato JSON (aluguel completo)
- Validação de senha com mensagens de erro ou “OK”
- Execução do resumo de quilômetros rodados por filial/modelo

---

## 🧾 Prints de Execução

As imagens a seguir demonstram os resultados obtidos durante os testes:

| Execução | Descrição |
|-----------|------------|
| ![Aluguel JSON](prints/print_aluguel_json.png) | Resultado da procedure `PRC_ALUGUEL_EM_JSON` |
| ![Resumo KM](prints/print_resumo_km.png) | Resultado da procedure `PRC_RESUMO_KM_POR_FILIAL_MODELO` |
| ![Validação de Senha](prints/print_senha.png) | Resultado da função `FN_VALIDAR_SENHA_COMPLEXIDADE` |
| ![Auditoria](prints/print_auditoria.png) | Registros gerados pela trigger de auditoria |

---

## 📊 Modelagem do Banco de Dados

Os diagramas **relacional e lógico** estão disponíveis no arquivo:
> `modelagem_relacional.pdf`

Contendo todas as tabelas do sistema, relacionamentos e chaves estrangeiras conforme a normalização do projeto.

---

## 🧠 Conclusão

O projeto **MotoTrack** foi concluído atendendo a todos os requisitos da Sprint 4:  
- Empacotamento completo das rotinas PL/SQL  
- Integração com backend Java  
- Exportação e estruturação de dados em MongoDB  
- Demonstração visual (prints substituindo vídeo)  
- Execução validada e sem erros

---

## 🛠️ Tecnologias Utilizadas
- **Oracle Database 21c**
- **MongoDB 7.x**
- **Java 17 (JDBC)**
- **SQL Developer / DBeaver**
- **Git & GitHub**

---

## 📦 Arquivos Gerados
- `dataset_alugueis.json`  
- `mongo_mototrack_import.js`  
- `pkg_mototrack.sql`  
- `test_pkg_mototrack.sql`  
- `DemoProcedures.java`  
- `prints` (4 arquivos PNG)  
- `modelagem_relacional.pdf`

---

## 🚀 Como Executar Tudo
1. Crie o banco Oracle e rode os scripts SQL.  
2. Gere o dataset JSON e importe no MongoDB.  
3. Compile e execute o código Java para chamar as procedures.  
4. Consulte os resultados conforme os prints.

---

## 🧾 Licença
Este projeto é de uso acadêmico e faz parte do curso **2TDSPW - FIAP**.
