import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final String title;
  final bool completed;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.title,
    required this.completed,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: completed,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          decoration: completed ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
