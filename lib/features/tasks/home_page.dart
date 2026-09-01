import 'package:corso/features/tasks/task.dart';
import 'package:corso/features/tasks/task_card.dart';
import 'package:corso/features/tasks/task_form_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      description: 'Leggere alemno 20 pagine',
    ),
  ];

  Future<void> _openTaskForm() async {
    final task = await Navigator.of(
      context,
    ).push<Task>(MaterialPageRoute(builder: (context) => const TaskFormPage()));

    if (task == null) {
      return;
    }

    setState(() {
      _tasks.add(task);
    });
  }

  void _toggleTaskCompleted(int index) {
    setState(() {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(completed: !task.completed);
    });
  }

  Future<void> _editTask(int index) async {
    final updatedTask = await Navigator.of(context).push<Task>(
      MaterialPageRoute(
          builder: (context) => TaskFormPage(
              task: _tasks[index]
          ),
      )
    );

    if (updatedTask == null) {
      return;
    }

    setState(() {
      _tasks[index] = updatedTask;
    });

  }

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

          return TaskCard(
            task: task,
            onToggleCompleted: () => _toggleTaskCompleted(index),
            onTap: () => _editTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTaskForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
