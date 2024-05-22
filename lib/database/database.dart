import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openAppDataDb() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'appData.db');

  return openDatabase(path, version: 1, onCreate: (Database db, int version) async {
    // Create website table
    await db.execute(
      'CREATE TABLE Website(id INTEGER PRIMARY KEY, name TEXT, url TEXT UNIQUE)',
    );

    await db.execute(
      'CREATE TABLE Ad('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'websiteUrl TEXT, '
      'title TEXT, '
      'url TEXT, '
      'location TEXT, '
      'year TEXT, '
      'mileage TEXT, '
      'price TEXT, '
      'sellerType TEXT, '
      'imageUrl TEXT, '
      'createdTime TEXT'
      ')',
    );
  });
}
