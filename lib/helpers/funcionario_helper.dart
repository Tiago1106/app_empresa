import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/funcionario_model.dart';

final String funcionarioTable = "funcionarioTable";
final String idFuncColumn = "idFuncColumn";
final String idEmpresaColumn = "idEmpresaColumn";
final String nameFuncColumn = "nameFuncColumn";
final String cargoColumn = "cargoColumn";
final String salarioColumn = "salarioColumn";

class FuncionarioHelper {
  static final FuncionarioHelper _instance = FuncionarioHelper.internal();

  factory FuncionarioHelper() => _instance;

  FuncionarioHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "funcionario.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $funcionarioTable($idFuncColumn INTEGER PRIMARY KEY, $idEmpresaColumn INTEGER, $nameFuncColumn TEXT, $cargoColumn INTEGER, $salarioColumn INTEGER)");
    });
  }

  Future<Funcionario> saveFuncionario(Funcionario funcionario) async {
    Database dbFuncionario = await db;
    funcionario.idFunc =
        await dbFuncionario.insert(funcionarioTable, funcionario.toMap());
    return funcionario;
  }

  Future<Funcionario> getFuncionario(int idFunc) async {
    Database dbFuncionario = await db;
    List<Map> maps = await dbFuncionario.query(funcionarioTable,
        columns: [
          idFuncColumn,
          idEmpresaColumn,
          nameFuncColumn,
          cargoColumn,
          salarioColumn
        ],
        where: "$idFuncColumn = ?",
        whereArgs: [idFunc]);
    if (maps.length > 0) {
      return Funcionario.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteFuncionario(int idFunc) async {
    Database dbFuncionario = await db;
    return await dbFuncionario.delete(funcionarioTable,
        where: "$idFuncColumn = ?", whereArgs: [idFunc]);
  }

  Future<int> updateFuncionario(Funcionario funcionario) async {
    Database dbContact = await db;
    return await dbContact.update(funcionarioTable, funcionario.toMap(),
        where: "$idFuncColumn = ?", whereArgs: [funcionario.idFunc]);
  }

  Future<List> getAllFuncEmpresa(int idEmpresa) async {
    Database dbFunc = await db;
    List listFuncMap =
    await dbFunc.query(funcionarioTable,
        where: "$idEmpresaColumn = ?", whereArgs: [idEmpresa]);
    List<Funcionario> listFunc = List();
    for (Map m in listFuncMap) {
      listFunc.add(Funcionario.fromMap(m));
    }
    return listFunc;
  }

 /* Future<List> queryAll() async {
    Database dbFuncionario = await db;
    List<Map> funcionarios =
      await dbFuncionario.rawQuery("select empresaTable.idColumn,"
          " count(Date.date) from Name left join Date using(id) group by Name.name");
    return funcionarios;
  }*/

  Future<int> getNumber() async {
    Database dbFuncionario = await db;
    return Sqflite.firstIntValue(
        await dbFuncionario.rawQuery("SELECT COUNT(*) FROM $funcionarioTable"));
  }

  Future close() async {
    Database dbFuncionario = await db;
    dbFuncionario.close();
  }
}