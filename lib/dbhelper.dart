import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final _databseName = "demo.db";
  static final _databseVersion = 1;

  static final table = "my_table";

  static final columnId = "id";
  static final columnName = "name";
  static final columnAge = "age";

  late Database _database;

  // Private constructor to prevent instantiation from outside.
  DbHelper._privateConstructor();

  // Singleton instance of DbHelper.
  static final DbHelper _instance = DbHelper._privateConstructor();

  // Factory constructor to provide access to the instance.
  factory DbHelper() {
    return _instance;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documetDirectoty = await getApplicationDocumentsDirectory();
    var path = join(documetDirectoty.path, _databseName);

    _database =
    await openDatabase(path, version: _databseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $table(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnAge INTEGER NOT NULL
      )
      ''');
  }

  // Helper methods

  // Insert
  Future<int> insertData(Map<String, dynamic> row) async {
    return await _database.insert(table, row);
  }

  //delete
  Future<int> delete(int id) async {
    return await _database.delete(
        table, where: '$columnId = ?', whereArgs: [id]);
  }

  //select
  Future<List<Map<String, Object?>>> getAllRows() async {
    return await _database.query(table);
  }

  //update
  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _database
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //count
  Future<int> getRowCount() async {
    final results = await _database.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }
}
