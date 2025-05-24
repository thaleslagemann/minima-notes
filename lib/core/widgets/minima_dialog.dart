import 'package:flutter/material.dart';

class MinimaDialog extends StatelessWidget {
  const MinimaDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const [],
  });

  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: AlertDialog(
        title: title,
        content: content,
        actions: actions,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16.0),
        ),
      ),
    );
  }
}
