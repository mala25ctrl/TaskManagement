class Task{
  final int id;
  final String title;
  final String description;
  final bool completed;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}