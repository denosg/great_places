import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sql.dart';

class DBHelper {
  // static method to insert the path of the image in an sqlite database
  static Future<void> insert(String table, Map<String, dynamic> data) async {
    // gets the path of the db
    final dbPath = await sql.getDatabasesPath();
    // opens the found db, if it exists, if it doesn't, it creates one
    final sqlDb = await sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    }, version: 1);
    // inserts the data in the sqlite db
    await sqlDb.insert(
      table,
      data,
      // ConflictAlgorithm.replace replaces the data for the specific id if it already exists
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
