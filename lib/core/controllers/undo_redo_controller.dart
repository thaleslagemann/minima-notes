import 'package:flutter/material.dart';

/// A TextEditingController that tracks edit history for undo/redo.
class UndoRedoController extends TextEditingController {
  final List<TextEditingValue> _undoStack = [];
  final List<TextEditingValue> _redoStack = [];
  bool _isPerformingUndoRedo = false;

  UndoRedoController({String? text}) : super(text: text) {
    // Seed with the initial value
    _undoStack.add(value);
    addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // If we're in the middle of undo/redo, don't record again
    if (_isPerformingUndoRedo) return;

    final current = value;
    final last = _undoStack.isNotEmpty ? _undoStack.last : null;

    // Only record if text or selection actually changed
    if (last == null || last.text != current.text || last.selection != current.selection) {
      _undoStack.add(current);
      _redoStack.clear();
    }
  }

  /// Undo the last edit (if any).
  void undo() {
    if (!canUndo) return;

    _isPerformingUndoRedo = true;
    // Move the current state to redo
    final last = _undoStack.removeLast();
    _redoStack.add(last);

    // Restore previous state
    final previous = _undoStack.last;
    value = previous;
    selection = previous.selection;

    _isPerformingUndoRedo = false;
  }

  /// Redo the last undone edit (if any).
  void redo() {
    if (!canRedo) return;

    _isPerformingUndoRedo = true;
    final next = _redoStack.removeLast();
    _undoStack.add(next);

    value = next;
    selection = next.selection;
    _isPerformingUndoRedo = false;
  }

  /// Whether there’s anything to undo.
  bool get canUndo => _undoStack.length > 1;

  /// Whether there’s anything to redo.
  bool get canRedo => _redoStack.isNotEmpty;

  @override
  void dispose() {
    removeListener(_onTextChanged);
    super.dispose();
  }
}
