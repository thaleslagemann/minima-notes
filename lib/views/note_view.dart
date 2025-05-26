import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:minima_notes/core/controllers/undo_redo_controller.dart';
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

class _NoteViewState extends ConsumerState<NoteView> with SingleTickerProviderStateMixin {
  TextEditingController titleController = TextEditingController();
  late final UndoRedoController textController;
  // TextEditingController textController = TextEditingController();

  late final AnimationController _debounceController;

  bool isEditingBody = false;
  bool isEditingTitle = false;

  void _handleEditPressed() {
    setState(() {
      isEditingBody = !isEditingBody;
    });
  }

  void _handleSavePressed() {
    if (_debounceController.isAnimating) {
      _debounceController.stop();
    }
    setState(() {
      widget.note.content = textController.text;
      ref.read(noteViewModelProvider.notifier).updateNote(widget.note);
    });
  }

  void _handleEditTitlePressed() {
    setState(() {
      isEditingTitle = true;
    });
  }

  void _handleSaveTitlePressed() {
    FocusManager.instance.primaryFocus!.unfocus();
    widget.note.title = titleController.text;
    ref.read(noteViewModelProvider.notifier).updateNote(widget.note);
    setState(() {
      isEditingTitle = false;
    });
  }

  void _setDebounce() {
    setState(() {
      _debounceController
        ..reset()
        ..forward();
    });
  }

  @override
  void initState() {
    titleController.text = widget.note.title;
    textController = UndoRedoController(text: widget.note.content);

    _debounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _handleSavePressed();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _debounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDebouncing = _debounceController.isAnimating;

    return Scaffold(
      drawer: MinimaDrawer(index: -1),
      appBar: AppBar(
        backgroundColor: AppTheme.grey10,
        title: TextFormField(
          controller: titleController,
          style: const TextStyle(color: AppTheme.white),
          scrollPadding: EdgeInsets.zero,
          maxLines: 1,
          cursorColor: AppTheme.white,
          onTap: () => _handleEditTitlePressed(),
          decoration: InputDecoration(
            suffixIcon:
                isEditingTitle
                    ? SizedBox(
                      height: 48,
                      width: 48,
                      child: IconButton(
                        onPressed: () => _handleSaveTitlePressed(),
                        icon: const Icon(
                          Icons.check,
                          color: AppTheme.white,
                        ),
                      ),
                    )
                    : null,
            contentPadding: EdgeInsets.zero,
            border: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.transparent)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.transparent)),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.transparent)),
          ),
        ),
        foregroundColor: AppTheme.white,
        leading: const BackButton(),
        actions: [
          if (isEditingBody)
            isDebouncing
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _handleSavePressed,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.save_outlined),
                    ),
                    isDebouncing
                        ? SizedBox(
                          width: 32,
                          child: AnimatedBuilder(
                            animation: _debounceController,
                            builder:
                                (context, _) => LinearProgressIndicator(
                                  value: _debounceController.value,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.white),
                                  backgroundColor: AppTheme.grey20,
                                ),
                          ),
                        )
                        : const SizedBox(),
                    const SizedBox(width: 8),
                  ],
                )
                : IconButton(
                  onPressed: _handleSavePressed,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child:
                    isEditingBody
                        ? Container(
                          decoration: const BoxDecoration(color: AppTheme.white),
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
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
                            onChanged: (v) => _setDebounce(),
                            onSubmitted: (v) => _handleSavePressed(),
                          ),
                        )
                        : Container(
                          decoration: const BoxDecoration(color: AppTheme.white),
                          child: MarkdownWidget(
                            data: widget.note.content,
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                          ),
                        ),
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isEditingBody)
                  Row(
                    children: [
                      Material(
                        color: AppTheme.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: textController.canUndo ? AppTheme.black : AppTheme.grey80,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: InkWell(
                          splashColor: AppTheme.grey40,
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: textController.canUndo ? () => setState(() => textController.undo()) : null,
                          child: SizedBox(
                            width: 48,
                            height: 24,
                            child: Icon(
                              Icons.undo,
                              color: textController.canUndo ? AppTheme.black : AppTheme.grey80,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                if (isEditingBody)
                  Row(
                    children: [
                      Material(
                        color: textController.canRedo ? AppTheme.white : AppTheme.greyB0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: textController.canRedo ? AppTheme.black : AppTheme.grey80,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: InkWell(
                          splashColor: AppTheme.grey40,
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: textController.canRedo ? () => setState(() => textController.redo()) : null,
                          child: SizedBox(
                            width: 48,
                            height: 24,
                            child: Icon(
                              Icons.redo,
                              color: textController.canRedo ? AppTheme.black : AppTheme.grey80,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                Material(
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
                    onTap: _handleEditPressed,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        isEditingBody ? Icons.visibility_outlined : Icons.edit_outlined,
                        color: AppTheme.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
