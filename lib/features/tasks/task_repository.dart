import 'package:corso/features/tasks/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Studiare Flutter',
      description: 'Completare la HomePage',
    ),
    const Task(
      id: 2,
      title: 'Fare esercizio',
      description: '30 minuti di allenamento',
      completed: true,
    ),
    const Task(
      id: 3,
      title: 'Leggere',
      description: 'Leggere almeno 20 pagine',
    ),
  ];

  List<Task> getAll() {
    return List.unmodifiable(_tasks);
  }

  void add(Task task) {
    _tasks.add(task);
  }

  void update(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);

    if (index == -1) {
      return;
    }

    _tasks[index] = task;
  }

  void delete(int id) {
    _tasks.removeWhere((t) => t.id == id);
  }

  void toggleCompleted(int id) {
    final index = _tasks.indexWhere((t) => t.id == id);

    if (index == -1) {
      return;
    }

    final task = _tasks[index];
    _tasks[index] = task.copyWith(completed: !task.completed);
  }
}
