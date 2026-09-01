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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            decoration: task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildPriorityBadge(context),
                if (dueDateLabel != null)
                  _buildInfoBadge(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: dueDateLabel,
                  ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildInfoBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 5),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;

    switch (task.priority) {
      case TaskPriority.low:
        backgroundColor = Colors.green.shade50;
        foregroundColor = Colors.green.shade700;
        break;

      case TaskPriority.medium:
        backgroundColor = Colors.orange.shade50;
        foregroundColor = Colors.orange.shade700;
        break;

      case TaskPriority.high:
        backgroundColor = Colors.red.shade50;
        foregroundColor = Colors.red.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _priorityLabel(),
        style: TextStyle(
          color: foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
