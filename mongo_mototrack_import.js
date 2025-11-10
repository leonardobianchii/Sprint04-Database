use mototrack;

db.createCollection("alugueis");
db.createCollection("motos");
db.createCollection("modelos");
db.createCollection("filiais");
db.createCollection("clientes");

db.alugueis.deleteMany({});
db.motos.deleteMany({});
db.modelos.deleteMany({});
db.filiais.deleteMany({});
db.clientes.deleteMany({});

// insert base dimensions
db.modelos.insertMany([
  {
    "_id": 1,
    "id": 1,
    "nome": "Honda CG 160"
  },
  {
    "_id": 2,
    "id": 2,
    "nome": "Yamaha Factor 150"
  },
  {
    "_id": 3,
    "id": 3,
    "nome": "Honda CB 500"
  },
  {
    "_id": 4,
    "id": 4,
    "nome": "Yamaha MT-07"
  },
  {
    "_id": 5,
    "id": 5,
    "nome": "Honda Biz 125"
  }
]);
db.filiais.insertMany([
  {
    "_id": 1,
    "id": 1,
    "nome": "Filial São Paulo"
  },
  {
    "_id": 2,
    "id": 2,
    "nome": "Filial Rio de Janeiro"
  },
  {
    "_id": 3,
    "id": 3,
    "nome": "Filial Campinas"
  },
  {
    "_id": 4,
    "id": 4,
    "nome": "Filial Belo Horizonte"
  },
  {
    "_id": 5,
    "id": 5,
    "nome": "Filial Curitiba"
  }
]);
db.clientes.insertMany([
  {
    "_id": 1,
    "id": 1,
    "nome": "Carlos Silva",
    "cpf": "123.456.789-00",
    "email": "carlos.silva@email.com"
  },
  {
    "_id": 2,
    "id": 2,
    "nome": "Ana Costa",
    "cpf": "987.654.321-00",
    "email": "ana.costa@email.com"
  },
  {
    "_id": 3,
    "id": 3,
    "nome": "João Pereira",
    "cpf": "111.222.333-44",
    "email": "joao.pereira@email.com"
  },
  {
    "_id": 4,
    "id": 4,
    "nome": "Mariana Alves",
    "cpf": "555.666.777-88",
    "email": "mariana.alves@email.com"
  },
  {
    "_id": 5,
    "id": 5,
    "nome": "Ricardo Gomes",
    "cpf": "999.000.111-22",
    "email": "ricardo.gomes@email.com"
  }
]);
db.motos.insertMany([
  {
    "_id": 1,
    "id": 1,
    "placa": "ABC-1234",
    "status": "Disponivel",
    "km_rodado": 15000,
    "modelo_id": 1,
    "filial_id": 1
  },
  {
    "_id": 2,
    "id": 2,
    "placa": "XYZ-5678",
    "status": "Em manutencao",
    "km_rodado": 8000,
    "modelo_id": 2,
    "filial_id": 2
  },
  {
    "_id": 3,
    "id": 3,
    "placa": "DEF-4321",
    "status": "Disponivel",
    "km_rodado": 12000,
    "modelo_id": 3,
    "filial_id": 3
  },
  {
    "_id": 4,
    "id": 4,
    "placa": "GHI-8765",
    "status": "Em manutencao",
    "km_rodado": 5000,
    "modelo_id": 4,
    "filial_id": 4
  },
  {
    "_id": 5,
    "id": 5,
    "placa": "JKL-1357",
    "status": "Disponível",
    "km_rodado": 7000,
    "modelo_id": 5,
    "filial_id": 5
  }
]);

// fact collection with references
db.alugueis.insertMany([
  {
    "_id": 1,
    "id_aluguel": 1,
    "periodo": {
      "retirada": "2025-05-12 08:00:00",
      "devolucao": "YYYY-MM-DD HH24:MI:SS"
    },
    "cliente": {
      "id": 1
    },
    "moto": {
      "id": 1
    }
  },
  {
    "_id": 2,
    "id_aluguel": 2,
    "periodo": {
      "retirada": "2025-05-10 14:00:00",
      "devolucao": "YYYY-MM-DD HH24:MI:SS"
    },
    "cliente": {
      "id": 2
    },
    "moto": {
      "id": 2
    }
  },
  {
    "_id": 3,
    "id_aluguel": 3,
    "periodo": {
      "retirada": "2025-05-11 09:00:00",
      "devolucao": "YYYY-MM-DD HH24:MI:SS"
    },
    "cliente": {
      "id": 3
    },
    "moto": {
      "id": 3
    }
  },
  {
    "_id": 4,
    "id_aluguel": 4,
    "periodo": {
      "retirada": "2025-05-10 10:00:00",
      "devolucao": "YYYY-MM-DD HH24:MI:SS"
    },
    "cliente": {
      "id": 4
    },
    "moto": {
      "id": 4
    }
  },
  {
    "_id": 5,
    "id_aluguel": 5,
    "periodo": {
      "retirada": "2025-05-12 12:00:00",
      "devolucao": "YYYY-MM-DD HH24:MI:SS"
    },
    "cliente": {
      "id": 5
    },
    "moto": {
      "id": 5
    }
  },
  {
    "_id": 9001,
    "id_aluguel": 9001,
    "periodo": {
      "retirada": "SYSTIMESTAMP",
      "devolucao": null
    },
    "cliente": {
      "id": 1
    },
    "moto": {
      "id": 1
    }
  }
]);

// helpful indexes
db.alugueis.createIndex({ "cliente.id": 1 });
db.alugueis.createIndex({ "moto.id": 1 });
db.alugueis.createIndex({ "periodo.retirada": 1 });
