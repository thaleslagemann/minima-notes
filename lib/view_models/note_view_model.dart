import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minima_notes/models/note_model.dart';
import 'package:minima_notes/services/note_service.dart';

class NoteViewModel extends Notifier<List<Note>> {
  NoteService service = NoteService();

  @override
  List<Note> build() {
    return []; // initial state
  }

  void addNote(Note note) async {
    await storeNote(note);
    await loadAllNotes();
  }

  void removeNote(Note note) async {
    await service.removeNote(note);
    final updated = [...state]..removeAt(state.indexWhere((e) => e.uuid == note.uuid));
    state = updated;
  }

  void updateNote(Note updatedNote) async {
    await service.storeNote(updatedNote);
    state = [
      for (final note in state)
        if (note.uuid == updatedNote.uuid) updatedNote else note,
    ];
    await loadAllNotes();
  }

  Future<bool> storeNote(Note note) async {
    return await service.storeNote(note);
  }

  Future<Note?> retrieveNoteByUuid(String uuid) async {
    return await service.retrieveNoteByUUid(uuid);
  }

  Future<void> loadAllNotes() async {
    state = [];
    List<Note>? notes = await service.retrieveAllNotes();
    if (notes != null && notes.isNotEmpty) {
      state = [...state, ...notes];
    }
  }
}

final noteViewModelProvider = NotifierProvider<NoteViewModel, List<Note>>(
  () => NoteViewModel(),
);
