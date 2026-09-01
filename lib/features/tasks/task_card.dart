import 'package:corso/features/tasks/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleCompleted;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            task.completed ? Icons.check_circle : Icons.radio_button_checked,
          ),
          onPressed: onToggleCompleted,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.description),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
