import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:looply/ui/features/revision_cycle/revision_cycle_view_model.dart';

class RevisionCycleDialog extends StatelessWidget {
  final String? initialName;
  final List<int>? initialCycle;
  final int? cycleId;

  const RevisionCycleDialog({
    super.key,
    this.initialName,
    this.initialCycle,
    this.cycleId,
  });

  @override
  Widget build(BuildContext context) {

    final nameController =
        TextEditingController(text: initialName ?? "");

    final cycleController =
        TextEditingController(
          text: initialCycle?.join(",") ?? "",
        );

    return AlertDialog(
      title: Text(cycleId == null ? "Adicionar Ciclo" : "Editar Ciclo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nome do ciclo",
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: cycleController,
            decoration: const InputDecoration(
              labelText: "Ciclo (ex: 1,3,7,15,30)",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final cycleText = cycleController.text.trim();

            if (name.isEmpty || cycleText.isEmpty) return;

            final cycle = cycleText
                .split(',')
                .map((e) => int.tryParse(e.trim()))
                .whereType<int>()
                .toList();

            if (cycle.isEmpty) return;

            final vm = context.read<RevisionCycleViewModel>();

            if (cycleId == null) {
              vm.insert(RevisionCycle(name, cycle));
            } else {
              vm.update(RevisionCycle(name, cycle, id: cycleId));
            }

            Navigator.of(context).pop();
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}