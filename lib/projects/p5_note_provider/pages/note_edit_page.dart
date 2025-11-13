import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';

class NoteEditPage extends StatefulWidget {
  final Note? note;

  const NoteEditPage({super.key, this.note});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late TextEditingController _controller;

  final Color primary = const Color.fromARGB(255, 83, 177, 117);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note?.text ?? "");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Note" : "New Note"),
        backgroundColor: primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: 12,
          decoration: InputDecoration(
            hintText: "Write something...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: primary, width: 2),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          final text = _controller.text.trim();

          // Kiểm tra text có rỗng không
          if (text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please write something!')),
            );
            return;
          }

          try {
            final provider = context.read<NoteProvider>();

            if (isEditing) {
              provider.updateNote(widget.note!.id, text);
            } else {
              provider.addNote(text);
            }

            Navigator.pop(context);
          } catch (e) {
            print('Error: $e');
          }
        },
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}