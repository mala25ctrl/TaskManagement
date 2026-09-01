import 'package:corso/features/tasks/task.dart';
import 'package:corso/features/tasks/task_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<Task> _tasks = [
    Task(id: 1, title: 'Task 1', description: 'Description 1'),
    Task(id: 2, title: 'Task 2', description: 'Description 2', completed: true),
    Task(id: 3, title: 'Task 3', description: 'Description 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          final task = _tasks[index];

          return TaskCard(task: task);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
