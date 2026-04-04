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
    final colorScheme = Theme.of(context).colorScheme;
 
    if (tags.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "Nenhuma tag disponível.",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.45),
              ),
        ),
      );
    }
 
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: tags.map((tag) {
          final isDefaultTag = tag.id == 0;
          if (isDefaultTag) selectedItems[tag.id!] = true;
 
          return CheckboxListTile(
            title: Text(tag.name),
            value: selectedItems[tag.id] ?? false,
            onChanged: isDefaultTag ? null : (_) => onChanged(tag.id),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
          );
        }).toList(),
      ),
    );
  }
}