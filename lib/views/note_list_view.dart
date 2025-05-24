import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minima_notes/core/theme/theme.dart';
import 'package:minima_notes/core/widgets/minima_button.dart';
import 'package:minima_notes/core/widgets/minima_dialog.dart';
import 'package:minima_notes/core/widgets/minima_drawer.dart';
import 'package:minima_notes/core/widgets/minima_text_field.dart';
import 'package:minima_notes/models/note_model.dart';
import 'package:minima_notes/view_models/note_view_model.dart';
import 'package:uuid/uuid.dart';

class NoteListView extends ConsumerWidget {
  const NoteListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Note> notes = ref.watch(noteViewModelProvider);
    final NoteViewModel viewModel = ref.read(noteViewModelProvider.notifier);

    return Scaffold(
      drawer: MinimaDrawer(index: 0),
      appBar: AppBar(
        backgroundColor: AppTheme.grey10,
        title: const Text(
          'MinimaNotes',
          style: TextStyle(color: AppTheme.white),
        ),
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: AppTheme.white,
            ),
            onPressed: () => _handleAddNote(context, viewModel),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: AppTheme.white),
              child:
                  notes.isEmpty
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: AppTheme.grey10),
                              children: [
                                TextSpan(text: 'To create your first '),
                                TextSpan(text: 'Note', style: TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(text: ", press the '"),
                                WidgetSpan(
                                  child: Icon(
                                    Icons.add,
                                    size: 18,
                                  ),
                                ),
                                TextSpan(text: "' icon."),
                              ],
                            ),
                          ),
                        ],
                      )
                      : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(notes[index].title),
                            onTap: () {
                              if (context.mounted) {
                                Navigator.pushNamed(context, '/note', arguments: notes[index]);
                              }
                            },
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  _handleAddNote(BuildContext context, NoteViewModel viewModel) async {
    final TextEditingController titleController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    Note? newNote;
    bool? add;

    add = await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return MinimaDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      color: AppTheme.grey30,
                      size: 24,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'Title',
                      style: TextStyle(
                        color: AppTheme.grey30,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                MinimaTextField(
                  controller: titleController,
                  required: true,
                  autoValidateMode: AutovalidateMode.onUnfocus,
                ),
              ],
            ),
          ),
          actions: [
            MinimaButton.ghost(
              label: 'Cancel',
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            MinimaButton.primary(
              label: 'Add',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  newNote = Note(
                    id: const Uuid().v1(),
                    title: titleController.text,
                    content: '',
                  );
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
        );
      },
    );
    if (add == null || newNote == null) {
      add = false;
    }
    if (add && newNote != null) {
      viewModel.addNote(newNote!);
      if (context.mounted) {
        Navigator.pushNamed(context, '/note', arguments: newNote);
      }
    }
    return;
  }
}
