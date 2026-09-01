import 'package:corso/features/tasks/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          task.completed ? Icons.check_circle : Icons.radio_button_checked,
        ),
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
