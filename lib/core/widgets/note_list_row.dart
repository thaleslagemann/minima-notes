import 'package:flutter/material.dart';
import 'package:minima_notes/core/theme/theme.dart';

class NoteListRow extends StatelessWidget {
  const NoteListRow({
    super.key,
    required this.title,
    this.icon,
    this.onTapCallback,
    this.onLongPressCallback,
  });

  final String title;
  final IconData? icon;
  final VoidCallback? onTapCallback;
  final VoidCallback? onLongPressCallback;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.white,
      child: InkWell(
        onTap: onTapCallback,
        onLongPress: onLongPressCallback,
        splashColor: AppTheme.grey80,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
