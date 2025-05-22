import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    // ✅ Ensure this is used if not already set (safe fallback)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final path = join(await getDatabasesPath(), 'settings.db');
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS settings (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              key TEXT UNIQUE,
              value TEXT
            )
          ''');
        },
      ),
    );
  }

  static Future<void> save(String key, String value) async {
    final db = await database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String?> getValue(String key) async {
    final db = await database;
    final result = await db.query('settings',
        where: 'key = ?', whereArgs: [key], limit: 1);
    return result.isNotEmpty ? result.first['value'] as String : null;
  }
}
