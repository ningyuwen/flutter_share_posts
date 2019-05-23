import 'dart:io';

import 'package:my_mini_app/been/post_around_been.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await _initDB();
    return _database;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "sharePost.db");
    return await openDatabase(path, version: 3, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE MyCollection ("
          "increaseId INTEGER PRIMARY KEY autoincrement,"
          "username TEXT,"
          "head_url TEXT,"
          "id INTEGER,"
          "distance INTEGER,"
          "isVote INTEGER,"
          "userId INTEGER,"
          "content TEXT,"
          "imgUrl TEXT,"
          "position TEXT,"
          "longitude DOUBLE,"
          "latitude DOUBLE,"
          "store TEXT,"
          "imgLabel TEXT,"
          "releaseTime TEXT,"
          "cost DOUBLE,"
          "votes INTEGER,"
          "comments INTEGER,"
          "district TEXT,"
          "storeId_meituan TEXT"
          ")");
    });
  }

  Future<int> insertCollection(Map map) async {
    final db = await database;
    List list =
        await db.query("MyCollection", where: "id = ?", whereArgs: [map['id']]);
    int res = 0;
    if (list.isEmpty) {
      res = await db.insert("MyCollection", map);
    }
    //res为0代表已存在，不为0则插入成功
    return res;
  }

  Future<List<Posts>> getAllCollection() async {
    final db = await database;
    var res = await db.rawQuery("select * from MyCollection order by increaseId desc");
//    var res = await db.query("MyCollection", orderBy: "increaseId");
    List<Posts> list =
        res.isNotEmpty ? res.map((c) => Posts.fromJson(c)).toList() : [];
    return list;
  }

  updateClient(Map map) async {
    final db = await database;
    var res = await db.update("MyCollection", map,
        where: "id = ?", whereArgs: [map['id']]);
    return res;
  }

  close() {
    if (_database.isOpen) {
      _database.close();
    }
  }
}
