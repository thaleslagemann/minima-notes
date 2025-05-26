import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minima_notes/core/helpers/text_format.dart';
import 'package:minima_notes/core/theme/theme.dart';
import 'package:minima_notes/core/widgets/minima_button.dart';
import 'package:minima_notes/core/widgets/minima_dialog.dart';
import 'package:minima_notes/core/widgets/minima_drawer.dart';
import 'package:minima_notes/core/widgets/minima_text_field.dart';
import 'package:minima_notes/core/widgets/note_list_row.dart';
import 'package:minima_notes/models/note_model.dart';
import 'package:minima_notes/view_models/note_view_model.dart';
import 'package:uuid/uuid.dart';

class NoteListView extends ConsumerStatefulWidget {
  const NoteListView({super.key});

  @override
  ConsumerState<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends ConsumerState<NoteListView> {
  getData() async {
    Future.microtask(() {
      ref.read(noteViewModelProvider.notifier).loadAllNotes();
    });
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: const [],
      ),
      body: Stack(
        children: [
          Column(
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
                              return NoteListRow(
                                title: notes[index].title,
                                icon: notes[index].icon ?? Icons.insert_drive_file_outlined,
                                onLongPressCallback: () => _handleLongPress(notes[index], viewModel),
                                onTapCallback: () {
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
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Material(
              color: AppTheme.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: AppTheme.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: InkWell(
                splashColor: AppTheme.grey40,
                borderRadius: BorderRadius.circular(16.0),
                onTap: () => _handleAddNote(context, viewModel),
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.add,
                    color: AppTheme.black,
                  ),
                ),
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
                    SizedBox(width: 8.0),
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
                    uuid: const Uuid().v1(),
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

  _handleRenameNote(Note note, NoteViewModel viewModel) async {
    final TextEditingController titleController = TextEditingController(text: note.title);
    final formKey = GlobalKey<FormState>();
    bool? rename;

    rename = await showDialog(
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
                      Icons.edit_outlined,
                      color: AppTheme.grey30,
                      size: 24,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Rename Note',
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
              label: 'Rename',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  note.title = titleController.text;

                  Navigator.pop(context, true);
                }
              },
            ),
          ],
        );
      },
    );
    rename ??= false;
    if (rename) {
      viewModel.updateNote(note);
    }
    return;
  }

  _handleLongPress(Note note, NoteViewModel viewModel) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Icon(note.icon ?? Icons.insert_drive_file_outlined),
                      const SizedBox(width: 8.0),
                      Text(
                        note.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Created at: ${TextFormat.getDateFormat(note.createdAt)}',
                          style: const TextStyle(fontSize: 10, color: AppTheme.grey60),
                        ),
                        Text(
                          'Last Updated at: ${TextFormat.getDateFormat(note.lastUpdatedAt)}',
                          style: const TextStyle(fontSize: 10, color: AppTheme.grey60),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 0),
                // ListTile(
                //   title: Text('Change Icon'),
                //   onTap: () => _handleSelectIcon(note, viewModel),
                // ),
                ListTile(
                  title: const Text('Rename'),
                  onTap: () => _handleRenameNote(note, viewModel),
                ),
                ListTile(
                  title: const Text('Delete'),
                  onTap: () => _handleDeleteNote(note, viewModel),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
    );
  }

  // _handleSelectIcon(Note note, NoteViewModel viewModel) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return MinimaDialog(
  //         title: const Text('Select a new Icon'),
  //         content: Container(
  //           height: MediaQuery.of(context).size.height * 0.6,
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemBuilder:
  //                       (context, index) => ListTile(
  //                         leading: Icon(),
  //                       ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  _handleDeleteNote(Note note, NoteViewModel viewModel) async {
    await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return MinimaDialog(
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.remove_circle_outline,
                    color: AppTheme.grey30,
                    size: 24,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    'Delete note?',
                    style: TextStyle(
                      color: AppTheme.grey30,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          content: Row(
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(color: AppTheme.black),
                  children: [
                    TextSpan(text: 'This action is '),
                    TextSpan(text: 'IRREVERSIBLE', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            MinimaButton.ghost(
              label: 'Cancel',
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            MinimaButton.primary(
              label: 'Delete',
              color: AppTheme.errorIndicator,
              onPressed: () {
                viewModel.removeNote(note);
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    if (mounted) Navigator.pop(context, true);
  }
}
