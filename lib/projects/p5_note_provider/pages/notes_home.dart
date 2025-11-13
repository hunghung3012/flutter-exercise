import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import 'note_edit_page.dart';

class NotesHomePage extends StatelessWidget {
  const NotesHomePage({super.key});

  final Color primary = const Color.fromARGB(255, 83, 177, 117);

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteProvider>().notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: primary,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditPage(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: notes.isEmpty
          ? const Center(
        child: Text(
          "No notes yet. Tap + to add.",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditPage(note: note),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primary.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      note.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<NoteProvider>().deleteNote(note.id);
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}