// date_picker_field.dart
import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.calendar_month),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor, selecione uma data";
        }
        return null;
      },
    );
  }
}