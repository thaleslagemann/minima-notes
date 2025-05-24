// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:minima_notes/core/theme/theme.dart';

class MinimaButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final ButtonStyle style;
  final Color? color;
  final IconData? icon;
  final bool forceUpperCase;

  const MinimaButton._({
    required this.onPressed,
    required this.label,
    required this.style,
    this.icon,
    this.forceUpperCase = false,
    this.color,
  });

  factory MinimaButton.primary({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
    Color color = AppTheme.black,
    bool forceUpperCase = false,
  }) {
    return MinimaButton._(
      label: forceUpperCase ? label.toUpperCase() : label,
      icon: icon,
      onPressed: onPressed,
      forceUpperCase: forceUpperCase,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppTheme.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16.0)),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      ),
    );
  }

  factory MinimaButton.outlined({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
    Color color = AppTheme.black,
    bool forceUpperCase = false,
  }) {
    return MinimaButton._(
      label: label,
      icon: icon,
      onPressed: onPressed,
      forceUpperCase: forceUpperCase,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.white,
        side: BorderSide(color: color),
        shadowColor: AppTheme.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16.0)),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      ),
    );
  }

  factory MinimaButton.ghost({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
    Color color = AppTheme.greyD0,
    bool forceUpperCase = false,
  }) {
    return MinimaButton._(
      label: label,
      icon: icon,
      onPressed: onPressed,
      forceUpperCase: forceUpperCase,
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.grey40,
        backgroundColor: color,
        shadowColor: AppTheme.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16.0)),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (style == TextButton.styleFrom()) {
      return TextButton(
        onPressed: onPressed,
        style: style,
        child: Text(forceUpperCase ? label.toUpperCase() : label),
      );
    } else if (style == OutlinedButton.styleFrom()) {
      return OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: Text(forceUpperCase ? label.toUpperCase() : label),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Text(forceUpperCase ? label.toUpperCase() : label),
      );
    }
  }
}
