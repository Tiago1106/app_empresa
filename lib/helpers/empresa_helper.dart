import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/empresa_model.dart';

final String empresaTable = "empresaTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String cepColumn = "cepColumn";
final String ruaColumn = "ruaColumn";
final String bairroColumn = "bairroColumn";
final String cidadeColumn = "cidadeColumn";
final String estadoColumn = "estadoColumn";
final String ncasaColumn = "ncasaColumn";
final String complementoColumn = "complementoColumn";
final String phoneColumn = "phoneColumn";

class EmpresaHelper {
  static final EmpresaHelper _instance = EmpresaHelper.internal();

  factory EmpresaHelper() => _instance;

  EmpresaHelper.internal();

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
    final path = join(databasesPath, "empresa.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $empresaTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $cepColumn TEXT, $ruaColumn TEXT, $bairroColumn TEXT, $cidadeColumn TEXT, $estadoColumn TEXT, $ncasaColumn TEXT, $complementoColumn TEXT, $phoneColumn TEXT)");
    });
  }

  Future<Empresa> saveEmpresa(Empresa empresa) async {
    Database dbEmpresa = await db;
    empresa.id = await dbEmpresa.insert(empresaTable, empresa.toMap());
    return empresa;
  }

  Future<Empresa> getEmpresa(int id) async {
    Database dbEmpresa = await db;
    List<Map> maps = await dbEmpresa.query(empresaTable,
        columns: [
          idColumn,
          nameColumn,
          cepColumn,
          ruaColumn,
          bairroColumn,
          cidadeColumn,
          estadoColumn,
          ncasaColumn,
          complementoColumn,
          phoneColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Empresa.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteEmpresa(int id) async {
    Database dbEmpresa = await db;
    return await dbEmpresa
        .delete(empresaTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateEmpresa(Empresa empresa) async {
    Database dbContact = await db;
    return await dbContact.update(empresaTable, empresa.toMap(),
        where: "$idColumn = ?", whereArgs: [empresa.id]);
  }

  Future<List> getAllEmpresa() async {
    Database dbEmpresa = await db;
    List listEmpresaMap =
        await dbEmpresa.rawQuery("SELECT * FROM $empresaTable");
    List<Empresa> listEmpresa = List();
    for (Map m in listEmpresaMap) {
      listEmpresa.add(Empresa.fromMap(m));
    }
    return listEmpresa;
  }

  Future<int> getNumber() async {
    Database dbEmpresa = await db;
    return Sqflite.firstIntValue(
        await dbEmpresa.rawQuery("SELECT COUNT(*) FROM $empresaTable"));
  }

  Future close() async {
    Database dbEmpresa = await db;
    dbEmpresa.close();
  }
}
