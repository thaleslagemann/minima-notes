import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minima_notes/core/theme/theme.dart';
import 'package:minima_notes/services/cache_service.dart';
import 'package:minima_notes/views/md_tutorial_view.dart';
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
            final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return NoteView(note: arguments['note'], firstVisit: arguments['firstVisit']);
          },
          '/md-tutorial': (context) => const MarkdownTutorialView(),
          '/settings': (context) => const SettingsView(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
