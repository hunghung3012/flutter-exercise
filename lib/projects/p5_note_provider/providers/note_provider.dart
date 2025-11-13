import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(String text) {
    _notes.add(Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
    ));
    notifyListeners();
  }

  void updateNote(String id, String newText) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index].text = newText;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
