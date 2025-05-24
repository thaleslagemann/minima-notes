import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minima_notes/models/note_model.dart';
import 'package:minima_notes/views/note_list_view.dart';
import 'package:minima_notes/views/note_view.dart';
import 'package:minima_notes/views/settings_view.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Minima Notes',
        theme: ThemeData(useMaterial3: true),
        initialRoute: '/notes',
        routes: {
          '/notes': (context) => const NoteListView(),
          '/note': (context) {
            final note = ModalRoute.of(context)!.settings.arguments as Note;
            return NoteView(note: note);
          },
          '/settings': (context) => const SettingsView(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
