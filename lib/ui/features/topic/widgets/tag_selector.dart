// tag_selector.dart
import 'package:flutter/material.dart';
import 'package:looply/model/tag.dart';

class TagSelector extends StatelessWidget {
  final List<Tag> tags;
  final Map<int, bool> selectedItems;
  final ValueChanged<int?> onChanged;

  const TagSelector({
    super.key,
    required this.tags,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...tags.map((tag) {
          final isDefaultTag = tag.id == 0;

          // Garante que a tag "Geral" está sempre selecionada
          if (isDefaultTag) selectedItems[tag.id!] = true;

          return CheckboxListTile(
            title: Text(tag.name),
            value: selectedItems[tag.id] ?? false,
            // Desabilita alteração se for a tag "Geral"
            onChanged: isDefaultTag ? null : (_) => onChanged(tag.id),
          );
        }),
      ],
    );
  }
}