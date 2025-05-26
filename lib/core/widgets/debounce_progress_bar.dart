import 'package:flutter/material.dart';

class DebounceProgressBar extends StatefulWidget {
  final Duration debounceDuration;
  final VoidCallback? onDebounceComplete;

  const DebounceProgressBar({
    super.key,
    required this.debounceDuration,
    this.onDebounceComplete,
  });

  @override
  State<DebounceProgressBar> createState() => _DebounceProgressBarState();
}

class _DebounceProgressBarState extends State<DebounceProgressBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.debounceDuration,
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.onDebounceComplete != null) widget.onDebounceComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: _controller.value,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      backgroundColor: Colors.grey[300],
    );
  }
}
