import 'package:sqflite/sqflite.dart';
import 'package:myfuture/repositories/database_connection.dart';

class Repository {
  late DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database> get database async =>
      _database ??= await _databaseConnection.setDatabase();

  insertData(table, data) async {
    var connection = await database;
    return connection.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return connection.query(table);
  }

  readDataById(table, itemId) async {
    var connection = await database;
    return connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  updateData(table, data) async {
    var connection = await database;
    return connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteData(table, data) async {
    var connection = await database;
    return connection.rawDelete('DELETE FROM $table WHERE id=$data');
  }
}
