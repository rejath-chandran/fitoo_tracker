import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Singleton helper for SQLite database initialization.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitoo_tracker.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE templates (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        name       TEXT    NOT NULL,
        tags       TEXT,
        created_at TEXT    DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE template_exercises (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        template_id INTEGER NOT NULL,
        name        TEXT    NOT NULL,
        sets        INTEGER DEFAULT 3,
        reps        INTEGER DEFAULT 10,
        weight      REAL    DEFAULT 0,
        sort_order  INTEGER DEFAULT 0,
        FOREIGN KEY (template_id) REFERENCES templates (id) ON DELETE CASCADE
      )
    ''');

    await _createGymSessionsTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createGymSessionsTable(db);
    }
  }

  Future<void> _createGymSessionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE gym_sessions (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        date              TEXT    NOT NULL,
        duration_minutes  INTEGER DEFAULT 0,
        intensity_percent INTEGER DEFAULT 0
      )
    ''');
  }
}
