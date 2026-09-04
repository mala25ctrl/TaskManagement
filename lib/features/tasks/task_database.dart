import 'package:corso/features/tasks/task_database_factory.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._();

  TaskDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databaseFactory = getDatabaseFactory();

    final String path;

    if (kIsWeb) {
      path = 'taskflow.db';
    } else {
      final databasePath = await getDatabasesPath();
      path = join(databasePath, 'taskflow.db');
    }

    return databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(version: 1, onCreate: _createDatabase),
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        completed INTEGER NOT NULL,
        priority INTEGER NOT NULL,
        dueDate TEXT
      )
    ''');
  }
}
