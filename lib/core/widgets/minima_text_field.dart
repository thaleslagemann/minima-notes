import 'package:flutter/material.dart';
import 'package:minima_notes/core/theme/theme.dart';

class MinimaTextField extends StatelessWidget {
  const MinimaTextField({
    super.key,
    required this.controller,
    this.required = false,
    this.autoValidateMode = AutovalidateMode.disabled,
  });

  final TextEditingController controller;
  final bool required;
  final AutovalidateMode autoValidateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: required ? (value) => value != null && value.isNotEmpty ? null : '* Required' : null,
      autovalidateMode: autoValidateMode,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppTheme.grey30, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppTheme.grey30, width: 4.0),
        ),
        errorStyle: const TextStyle(color: AppTheme.errorIndicator, fontWeight: FontWeight.w700),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppTheme.errorIndicator, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppTheme.errorIndicator, width: 4.0),
        ),
      ),
    );
  }
}
