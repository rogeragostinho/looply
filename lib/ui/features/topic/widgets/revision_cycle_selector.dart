// revision_cycle_selector.dart
import 'package:flutter/material.dart';
import 'package:looply/core/constants/topic_constants.dart';

class RevisionCycleSelector extends StatelessWidget {
  final ValueChanged<String?> onChanged;
  final TextEditingController textController;
  final String? selectedRevisionCycle;

  const RevisionCycleSelector({
    super.key,

    required this.onChanged,
    required this.textController,
    required this.selectedRevisionCycle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioGroup(
          groupValue: selectedRevisionCycle,
          onChanged: onChanged,
          child: Column(
            children: <Widget>[
              RadioListTile(
                value: TopicConstants.selectDefaultRevisionCycle,
                title: Text("Padrão ${TopicConstants.defaultRevisionCycle}"),
              ),
              RadioListTile(
                value: TopicConstants.selectOtherRevisionCycle,
                title: Text("Outro"),
              ),
            ],
          ),
        ),

        selectedRevisionCycle == TopicConstants.selectOtherRevisionCycle
            ? TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: "Ciclo (ex: 1,3,7,15,30)",
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
