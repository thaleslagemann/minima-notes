import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minima_notes/models/note_model.dart';

class NoteViewModel extends Notifier<List<Note>> {
  @override
  List<Note> build() {
    return []; // initial state
  }

  void addNote(Note note) {
    state = [...state, note];
  }

  void removeNoteAt(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
  }

  void updateNoteAt(Note updatedNote) {
    state = [
      for (final note in state)
        if (note.id == updatedNote.id) updatedNote else note,
    ];
  }
}

final noteViewModelProvider = NotifierProvider<NoteViewModel, List<Note>>(
  () => NoteViewModel(),
);
