import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minima_notes/services/note_service.dart';

final noteServiceProvider = Provider<NoteService>((ref) => NoteService());
