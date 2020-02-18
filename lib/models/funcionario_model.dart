import '../helpers/funcionario_helper.dart';

class Funcionario {
  int idFunc;
  int idEmpresa;
  String nameFunc;
  String cargo;
  int salario;

  Funcionario();

  Funcionario.fromMap(Map mapFunc) {
    idFunc = mapFunc[idFuncColumn];
    idEmpresa = mapFunc[idEmpresaColumn];
    nameFunc = mapFunc[nameFuncColumn];
    cargo = mapFunc[cargoColumn];
    salario = mapFunc[salarioColumn];
  }

  Map toMap() {
    Map<String, dynamic> mapFunc = {
      idFuncColumn: idFunc,
      idEmpresaColumn: idEmpresa,
      nameFuncColumn: nameFunc,
      cargoColumn: cargo,
      salarioColumn: salario
    };
    return mapFunc;
  }

  @override
  String toString() {
    return "Funcionario(idFunc: $idFunc, idEmpresa: $idEmpresa, name: $nameFunc, cargo: $cargo, salario: $salario)";
  }
}
