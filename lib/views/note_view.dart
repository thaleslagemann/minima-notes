import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:minima_notes/core/theme/theme.dart';
import 'package:minima_notes/core/widgets/minima_drawer.dart';
import 'package:minima_notes/models/note_model.dart';
import 'package:minima_notes/view_models/note_view_model.dart';

class NoteView extends ConsumerStatefulWidget {
  const NoteView({super.key, required this.note});

  final Note note;

  @override
  ConsumerState<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends ConsumerState<NoteView> {
  TextEditingController textController = TextEditingController();
  bool isEditing = false;

  void _handleEditPressed() {
    setState(() {
      isEditing = true;
    });
  }

  void _handleSavePressed() {
    widget.note.content = textController.text;
    ref.read(noteViewModelProvider.notifier).updateNote(widget.note);
    setState(() {
      isEditing = false;
    });
  }

  @override
  void initState() {
    textController.text = widget.note.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MinimaDrawer(index: -1),
      appBar: AppBar(
        backgroundColor: AppTheme.grey10,
        title: Text(
          widget.note.title,
          style: const TextStyle(color: AppTheme.white),
        ),
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            onPressed: isEditing ? _handleSavePressed : _handleEditPressed,
            icon: Icon(isEditing ? Icons.save_outlined : Icons.edit_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: AppTheme.white),
              padding: const EdgeInsets.all(16.0),
              child:
                  isEditing
                      ? TextField(
                        controller: textController,
                        minLines: 100,
                        maxLines: null,
                        scrollPadding: EdgeInsets.zero,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.transparent)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.transparent)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.transparent)),
                        ),
                        onSubmitted: (v) => _handleSavePressed(),
                      )
                      : MarkdownWidget(
                        data: widget.note.content,
                        padding: EdgeInsets.zero,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
