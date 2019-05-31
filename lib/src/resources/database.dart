import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class DBProvider {
  static Database _database;

  static Future<Database> get database async {
    if (_database == null)
      _database = await initDB();
    return _database;
  }

  static initDB() async {
    String path = join(await getDatabasesPath(), "birthday_database.db");
    print("Initialize database");  //TODO remove print
    return await openDatabase(
      path,
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
      onCreate: (Database db, int version) async {
        print("Creating Database in " + path);  //TODO remove print
        await db.execute("CREATE TABLE birthday (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, birthday TEXT NOT NULL, favorite INTEGER NOT NULL)");
      },
    );
  }
}
