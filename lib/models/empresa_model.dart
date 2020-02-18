import '../helpers/empresa_helper.dart';

class Empresa {
  String ncasa;
  String complemento;
  String phone;
  int id;
  String name;
  String cep;
  String rua;
  String bairro;
  String cidade;
  String estado;

  Empresa();

  Empresa.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    cep = map[cepColumn];
    rua = map[ruaColumn];
    bairro = map[bairroColumn];
    cidade = map[cidadeColumn];
    estado = map[estadoColumn];
    ncasa = map[ncasaColumn];
    complemento = map[complementoColumn];
    phone = map[phoneColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      cepColumn: cep,
      ruaColumn: rua,
      bairroColumn: bairro,
      cidadeColumn: cidade,
      estadoColumn: estado,
      ncasaColumn: ncasa,
      complementoColumn: complemento,
      phoneColumn: phone,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Empresa(id: $id, name: $name, cep: $cep, rua: $rua, bairro: $bairro, cidade: $cidade, estado $estado, n Casa: $ncasa, complemento: $complemento, telefone: $phone)";
  }
}