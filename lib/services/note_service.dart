import 'dart:convert';

import 'package:minima_notes/models/note_model.dart';
import 'package:minima_notes/services/cache_service.dart';

class NoteService {
  Future<bool> storeNote(Note note) async {
    return await CacheService.instance.store(
      note.uuid,
      jsonEncode({
        'title': note.title,
        'content': note.content,
      }),
      null,
    );
  }

  Future<bool> removeNote(Note note) async {
    return await CacheService.instance.remove(note.uuid);
  }

  Future<Note?> retrieveNoteByUUid(String uuid) async {
    final res = await CacheService.instance.getByUuid(uuid);
    if (res.status == '000' && res.data != null) {
      return Note.fromMap(res.data!.first);
    } else {
      return null;
    }
  }

  Future<List<Note>?> retrieveAllNotes() async {
    final res = await CacheService.instance.getAll();
    if (res.status == '000' && res.data != null) {
      List<Note> notes = List.from(
        res.data!.map(
          (e) => Note.fromMap({
            'uuid': e['uuid'],
            'title': jsonDecode(e['data'])['title'],
            'content': jsonDecode(e['data'])['content'],
            'createdAt': DateTime.parse(e['createdAt']),
            'lastUpdatedAt': DateTime.parse(e['lastUpdatedAt']),
          }),
        ),
      );
      return notes;
    } else {
      return null;
    }
  }
}
