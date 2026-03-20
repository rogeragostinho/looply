// revision_cycle_selector.dart
import 'package:flutter/material.dart';
import 'package:looply/model/revision_cycle.dart';

class RevisionCycleSelector extends StatelessWidget {
  final List<RevisionCycle> cycles;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const RevisionCycleSelector({
    super.key,
    required this.cycles,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cycles.map((cycle) {
        return RadioListTile<int>(
          value: cycle.id!,
          groupValue: selectedId,
          title: Text("${cycle.name} ${cycle.cycle}"),
          onChanged: onChanged,
        );
      }).toList(),
    );
  }
}