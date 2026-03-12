import 'package:flutter/material.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/features/revision_cycle/revision_cycle_view_model.dart';
import 'package:looply/ui/features/revision_cycle/widgets/revision_cycle_dialog.dart';
import 'package:provider/provider.dart';

class RevisionCyclesPage extends StatefulWidget {
  const RevisionCyclesPage({super.key});

  @override
  State<RevisionCyclesPage> createState() => _RevisionCyclesPageState();
}

class _RevisionCyclesPageState extends State<RevisionCyclesPage> {

  @override
  void initState() {
    super.initState();
    // Chama loadTopics apenas depois que o widget estiver montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RevisionCycleViewModel>().loadRevisionCycles();
    });
  }

  @override
  Widget build(BuildContext context) {
    RevisionCycleViewModel revisionCycleVM = context.watch<RevisionCycleViewModel>();

    return Scaffold(
      appBar: AppTopBar(title: "Ciclos de Rvisão"),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
            showDialog(context: context, builder: (context) => RevisionCycleDialog()); // adicionar nova tag
          }, child: Text("Adicionar")),
          Expanded(
            child: ListView.builder(
              itemCount: revisionCycleVM.revisionCycles.length,
              itemBuilder: (context, index) {
                final revisionCycle = revisionCycleVM.revisionCycles[index];
              
                return Card(
                  child: Row(
                    children: [
                      Text("${revisionCycle.id} - ${revisionCycle.name} - ${revisionCycle.cycle}"),
                      ElevatedButton.icon(onPressed: () {
                         showDialog(context: context, builder: (context) => RevisionCycleDialog(initialName: revisionCycle.name, initialCycle: revisionCycle.cycle, cycleId: revisionCycle.id,));
                      }, label: Icon(Icons.edit)),
                      ElevatedButton.icon(onPressed: () {
                        revisionCycleVM.delete(revisionCycle.id!);
                      }, label: Icon(Icons.delete)),
                    ],
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}