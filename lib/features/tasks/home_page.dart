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
    final result = await Navigator.of(context).push<TaskFormResult>(
      MaterialPageRoute(builder: (context) => const TaskFormPage()),
    );

    if (result?.task == null) {
      return;
    }

    setState(() {
      _tasks.add(result!.task!);
    });
  }

  void _toggleTaskCompleted(int index) {
    setState(() {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(completed: !task.completed);
    });
  }

  Future<void> _editTask(int index) async {
    final result = await Navigator.of(context).push<TaskFormResult>(
      MaterialPageRoute(
        builder: (context) => TaskFormPage(task: _tasks[index]),
      ),
    );

    if (result == null) {
      return;
    }

    if (result.action == TaskFormAction.delete) {
      setState(() {
        _tasks.removeAt(index);
      });

      return;
    }

    if (result.task != null) {
      setState(() {
        _tasks[index] = result.task!;
      });
    }
  }

  int get _completedTasks {
    return _tasks.where((task) => task.completed).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow')),
      body: Padding(
          padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'I miei task',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 4),

            Text(
              '$_completedTasks di ${_tasks.length} completati',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index){
                      final task = _tasks[index];

                      return TaskCard(
                        task: task,
                        onToggleCompleted: () => _toggleTaskCompleted(index),
                        onTap: () => _editTask(index),
                      );
                    },
                    separatorBuilder: (context, index){
                      return const SizedBox(height: 12);
                    },
                    itemCount: _tasks.length
                )
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTaskForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
