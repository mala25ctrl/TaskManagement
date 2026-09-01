import 'package:corso/features/tasks/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleCompleted;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleCompleted,
    required this.onTap,
  });

  String _priorityLabel() {
    switch (task.priority) {
      case TaskPriority.low:
        return 'Bassa';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  String? _dueDateLabel() {
    final dueDate = task.dueDate;

    if (dueDate == null) {
      return null;
    }

    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dueDateLabel = _dueDateLabel();

    return Card(
      child: ListTile(
        onTap: onTap,
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(task.description),
            ],

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  label: Text(_priorityLabel()),
                  visualDensity: VisualDensity.compact,
                ),
                if (dueDateLabel != null)
                  Chip(
                    avatar: const Icon(Icons.calendar_today_outlined, size: 16),
                    label: Text(dueDateLabel),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
