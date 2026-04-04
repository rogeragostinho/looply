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
    final showCustomField =
        selectedRevisionCycle == TopicConstants.selectOtherRevisionCycle;
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              RadioListTile<String>(
                value: TopicConstants.selectDefaultRevisionCycle,
                groupValue: selectedRevisionCycle,
                onChanged: onChanged,
                title: Text("Padrão ${TopicConstants.defaultRevisionCycle}"),
                dense: true,
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                value: TopicConstants.selectOtherRevisionCycle,
                groupValue: selectedRevisionCycle,
                onChanged: onChanged,
                title: const Text("Personalizado"),
                dense: true,
              ),
            ],
          ),
        ),
        if (showCustomField) ...[
          const SizedBox(height: 12),
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Ciclo (ex: 1,3,7,15,30)",
              hintText: "Separa os dias por vírgula",
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ],
    );
  }
}