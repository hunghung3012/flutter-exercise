import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/todo_item.dart';
import 'dart:convert';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _controller = TextEditingController();

  final Color primary = const Color.fromARGB(255, 83, 177, 117);

  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks
  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString("tasks");

    if (tasksString != null) {
      setState(() {
        tasks = List<Map<String, dynamic>>.from(json.decode(tasksString));
      });
    }
  }

  // Save tasks
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("tasks", json.encode(tasks));
  }

  // Add Task
  void _addTask() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      tasks.add({
        "title": _controller.text.trim(),
        "completed": false,
      });
      _controller.clear();
    });

    _saveTasks();
  }

  // Toggle Completed
  void _toggleTask(int index) {
    setState(() {
      tasks[index]["completed"] = !tasks[index]["completed"];
    });

    _saveTasks();
  }

  // Delete Task
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });

    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        backgroundColor: primary,
      ),

      body: Column(
        children: [
          // INPUT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Enter task...",
                      labelStyle: TextStyle(
                        color: Colors.black,            // 🔵 label color
                        fontWeight: FontWeight.w500,
                      ),
                      border: const OutlineInputBorder(),

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary, width: 2),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary.withOpacity(0.5)),
                      ),
                    ),

                  ),
                ),
                const SizedBox(width: 5),

                // NÚT ADD MÀU XANH CHỦ ĐẠO
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _addTask,
                  child: const Text("+"),
                ),
              ],
            ),
          ),

          // DANH SÁCH TASK
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    TodoItem(
                      title: tasks[index]["title"],
                      completed: tasks[index]["completed"],
                      onToggle: () => _toggleTask(index),
                      onDelete: () => _deleteTask(index),
                    ),

                    // PHÂN CÁCH GIỮA CÁC TASK
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: primary.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
