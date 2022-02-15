import 'package:flutter/scheduler.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class SQLHelper {
  static Future<sqlite.Database> db() async {
    return sqlite.openDatabase("info.db", version: 3,
        onCreate: (sqlite.Database database, int version) {
      database.execute(
          "CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, description TEXT)");
    });
  }

  //Data Insert Function
  //return type int, data jkhn table a insert hobe tkhn row akare add hoy
  //row 1 theke suru hoy, jodi -1 ace tahole bujte hobe data insert hocce na kono error ace

  static Future<int> insertData(String title, String description) async {
    final db = await SQLHelper.db();
    var values = {"title": title, "description": description};
    return db.insert("note", values);
  }

  // getData Function
  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    return db.query("note", orderBy: "id");
  }

  static Future<int> updateData(
      int id, String title, String description) async {
    final db = await SQLHelper.db();
    var values = {"title": title, "description": description};
    return db.update("note", values, where: "id = ?", whereArgs: [id]);
  }

  static Future<int> deleteData(int id) async {
    final db = await SQLHelper.db();
    return db.delete("note", where: "id = ?", whereArgs: [id]);
  }
}
