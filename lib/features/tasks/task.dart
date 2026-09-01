enum TaskPriority { low, medium, high }

class Task {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final TaskPriority priority;
  final DateTime? dueDate;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
    this.priority = TaskPriority.medium,
    this.dueDate,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    TaskPriority? priority,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
