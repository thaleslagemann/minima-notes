import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minima_notes/core/theme/theme.dart';
import 'package:minima_notes/models/note_model.dart';
import 'package:minima_notes/services/cache_service.dart';
import 'package:minima_notes/views/note_list_view.dart';
import 'package:minima_notes/views/note_view.dart';
import 'package:minima_notes/views/settings_view.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  loadCache() async {
    CacheService.instance.openDB();
  }

  @override
  void initState() {
    loadCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Minima Notes',
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppTheme.grey10,
            selectionColor: AppTheme.grey10.withAlpha(100),
            selectionHandleColor: AppTheme.grey10.withAlpha(225),
          ),
          useMaterial3: true,
        ),
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
