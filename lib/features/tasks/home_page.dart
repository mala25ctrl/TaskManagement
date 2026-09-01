import 'package:corso/features/tasks/task.dart';
import 'package:corso/features/tasks/task_card.dart';
import 'package:corso/features/tasks/task_form_page.dart';
import 'package:corso/features/tasks/task_repository.dart';
import 'package:flutter/material.dart';

enum TaskFilter { all, pending, completed }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskFilter _selectedFilter = TaskFilter.all;
  final TaskRepository _repository = TaskRepository();
  late List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _repository.getAll();

    if (!mounted) return;

    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _openTaskForm() async {
    final result = await Navigator.of(context).push<TaskFormResult>(
      MaterialPageRoute(builder: (context) => const TaskFormPage()),
    );

    if (result?.task == null) {
      return;
    }

    await _repository.add(result!.task!);
    await _loadTasks();
  }

  Future<void> _toggleTaskCompleted(Task task) async {
    await _repository.toggleCompleted(task.id);
    await _loadTasks();
  }

  Future<void> _editTask(Task task) async {
    final result = await Navigator.of(context).push<TaskFormResult>(
      MaterialPageRoute(builder: (context) => TaskFormPage(task: task)),
    );

    if (result == null) {
      return;
    }

    if (result.action == TaskFormAction.delete) {
      await _repository.delete(task.id);
      await _loadTasks();
      return;
    }

    if (result.task != null) {
      await _repository.update(result.task!);
      await _loadTasks();
    }
  }

  int get _completedTasks {
    return _tasks.where((task) => task.completed).length;
  }

  List<Task> get _filteredTasks {
    switch (_selectedFilter) {
      case TaskFilter.pending:
        return _tasks.where((task) => !task.completed).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.completed).toList();
      case TaskFilter.all:
        return _tasks;
    }
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

            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Tutti'),
                  selected: _selectedFilter == TaskFilter.all,
                  onSelected: (_) {
                    setState(() {
                      _selectedFilter = TaskFilter.all;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('In sospeso'),
                  selected: _selectedFilter == TaskFilter.pending,
                  onSelected: (_) {
                    setState(() {
                      _selectedFilter = TaskFilter.pending;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Completati'),
                  selected: _selectedFilter == TaskFilter.completed,
                  onSelected: (_) {
                    setState(() {
                      _selectedFilter = TaskFilter.completed;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: _filteredTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            _selectedFilter == TaskFilter.all
                                ? 'Nessun task'
                                : 'Nessun task in questa categoria',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            _selectedFilter == TaskFilter.all
                                ? 'Premi + per creare il tuo primo task'
                                : 'Prova a selezionare un altro filtro',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];

                        return TaskCard(
                          task: task,
                          onToggleCompleted: () => _toggleTaskCompleted(task),
                          onTap: () => _editTask(task),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 12);
                      },
                      itemCount: _filteredTasks.length,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTaskForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
