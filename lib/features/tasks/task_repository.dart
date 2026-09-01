import 'package:corso/features/tasks/task.dart';
import 'package:corso/features/tasks/task_database.dart';

class TaskRepository {
  final TaskDatabase _database = TaskDatabase.instance;

  Future<List<Task>> getAll() async{
    final db = await _database.database;
    
    final maps = await db.query('tasks');
    
    return maps
        .map((map) => Task.fromMap(map))
        .toList();
  }

  Future<void> add(Task task) async {
    final db = await _database.database;

    await db.insert(
      'tasks',
      task.toMap(),
    );
  }

  Future<void> update(Task task) async {
    final db = await _database.database;

    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _database.database;

    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleCompleted(int id) async {
    final db = await _database.database;

    final maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return;
    }

    final task = Task.fromMap(maps.first);

    final updatedTask = task.copyWith(completed: !task.completed);

    await update(updatedTask);
  }

}
