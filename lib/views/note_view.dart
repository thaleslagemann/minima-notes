import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:minima_notes/core/theme/theme.dart';
import 'package:minima_notes/core/widgets/minima_drawer.dart';
import 'package:minima_notes/models/note_model.dart';

class NoteView extends ConsumerWidget {
  const NoteView({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: MinimaDrawer(index: -1),
      appBar: AppBar(
        backgroundColor: AppTheme.grey10,
        title: Text(
          note.title,
          style: const TextStyle(color: AppTheme.white),
        ),
        foregroundColor: AppTheme.white,
        actions: [IconButton(onPressed: () => _handleEditPressed(), icon: const Icon(Icons.edit_outlined))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: AppTheme.white),
                child: MarkdownWidget(data: note.content),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleEditPressed() {}
}
