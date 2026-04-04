// topic_text_field.dart
import 'package:flutter/material.dart';

class TopicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const TopicTextField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Por favor, insira $label";
        }
        return null;
      },
    );
  }
}