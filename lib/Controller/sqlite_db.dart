import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDB{
  static const String _dbName = "lab_db";

  Database? _db;

  SQLiteDB._();
  static final SQLiteDB _instance = SQLiteDB._();

  factory SQLiteDB(){
    return _instance;
  }

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    String path = join(await getDatabasesPath(), _dbName,);
    _db = await openDatabase(path, version: 1, onCreate: (createDb, version) async {
      for(String tableSql in SQLiteDB.tableSQLStrings){
        await createDb.execute(tableSql);
      }
    },);
    return _db!;
  }

  static List<String> tableSQLStrings = [
    '''
    CREATE TABLE IF NOT EXISTS expense (id INTEGER PRIMARY KEY AUTOINCREMENT, 
    amount DOUBLE,
    desc TEXT,
    dateTime DATETIME)
    ''',
  ];

  Future<int> insert (String tableName, Map<String, dynamic> row) async {
    Database db = await _instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await _instance.database;
    return await db.query(tableName);
  }

  Future<int> update(String tableName, String idColumn, Map<String, dynamic> row) async {
    Database db = await _instance.database;
    dynamic id = row[idColumn];
    return await db.update(tableName, row, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> delete(String tableName, String idColumn, dynamic idValue) async {
    Database db = await _instance.database;
    return await db.delete(tableName, where: '$idColumn = ?', whereArgs: [idValue]);
  }

  //Testing Database
  Future<int?> countRecords(String tableName) async {
    Database db = await _instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }
}