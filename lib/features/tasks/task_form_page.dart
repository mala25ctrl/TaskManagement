import 'package:corso/features/tasks/task.dart';
import 'package:flutter/material.dart';

enum TaskFormAction { save, delete }

class TaskFormResult {
  final TaskFormAction action;
  final Task? task;

  TaskFormResult({required this.action, this.task});
}

class TaskFormPage extends StatefulWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );

    _priority = widget.task?.priority ?? TaskPriority.medium;
    _dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      completed: widget.task?.completed ?? false,
      priority: _priority,
      dueDate: _dueDate,
    );

    Navigator.of(context)
        .pop(TaskFormResult(action: TaskFormAction.save, task: task));
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina task'),
        content: const Text('Sei sicuro di voler eliminare questo task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    if (!mounted) return;

    Navigator.of(context).pop(TaskFormResult(action: TaskFormAction.delete));
  }

  Future<void> _selectDueDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _dueDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nuovo Task' : 'Modifica Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titolo'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci un titolo';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrizione'),
                maxLines: 4,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: 'Priorità'),
                items: const [
                  DropdownMenuItem(
                    value: TaskPriority.low,
                    child: Text('Bassa'),
                  ),
                  DropdownMenuItem(
                    value: TaskPriority.medium,
                    child: Text('Media'),
                  ),
                  DropdownMenuItem(
                    value: TaskPriority.high,
                    child: Text('Alta'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _priority = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(
                  _dueDate == null
                      ? 'Nessuna scadenza'
                      : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                ),
                trailing: TextButton(
                  onPressed: _selectDueDate,
                  child: const Text('Seleziona data'),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveTask,
                child: Text(widget.task == null ? 'Salva' : 'Aggiorna'),
              ),

              if (widget.task != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _deleteTask,
                    child: const Text('Elimina task'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
