// add_topic_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/features/topic/widgets/topic_text_field.dart';
import 'package:looply/ui/features/topic/widgets/date_picker_field.dart';
import 'package:looply/ui/features/topic/widgets/revision_cycle_selector.dart';
import 'package:looply/ui/features/topic/widgets/tag_selector.dart';
import 'package:looply/ui/features/revision_cycle/revision_cycle_view_model.dart';
import 'package:looply/ui/features/tag/tag_view_model.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:provider/provider.dart';

class AddTopicPage extends StatefulWidget {
  const AddTopicPage({super.key});

  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  final _formKey = GlobalKey<FormState>();
  final topicController = TextEditingController();
  final studiedOnController = TextEditingController();
  DateTime studiedOn = DateTime.now();
  int? selectedCycleId;
  RevisionCycle? selectedCycle;
  bool isSaving = false;
  final Map<int, bool> selectedTags = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Carrega dados
      final revisionVM = context.read<RevisionCycleViewModel>();
      final tagVM = context.read<TagViewModel>();
      
      revisionVM.loadRevisionCycles();
      tagVM.loadTags();

      // Seleciona automaticamente o primeiro ciclo, se existir
      if (revisionVM.revisionCycles.isNotEmpty) {
        setState(() {
          selectedCycle = revisionVM.revisionCycles.first;
          selectedCycleId = selectedCycle!.id;
        });
      }
    });

    studiedOnController.text =
        '${studiedOn.day}/${studiedOn.month}/${studiedOn.year}';
  }

  @override
  void dispose() {
    topicController.dispose();
    studiedOnController.dispose();
    super.dispose();
  }

  void selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: studiedOn,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        studiedOn = picked;
        studiedOnController.text =
            '${studiedOn.day}/${studiedOn.month}/${studiedOn.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final revisionCycleVM = context.watch<RevisionCycleViewModel>();
    final tagVM = context.watch<TagViewModel>();
    final topicVM = context.read<TopicViewModel>();

    return Scaffold(
      appBar: const AppTopBar(title: "Novo Tópico"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopicTextField(controller: topicController, label: "Tópico*"),
                const SizedBox(height: 25),
                DatePickerField(
                  controller: studiedOnController,
                  onTap: selectDate,
                ),
                const SizedBox(height: 25),
                const Text("Ciclo de Revisão"),
                RevisionCycleSelector(
                  cycles: revisionCycleVM.revisionCycles,
                  selectedId: selectedCycleId,
                  onChanged: (val) {
                    setState(() {
                      selectedCycleId = val;
                      selectedCycle = revisionCycleVM.revisionCycles.firstWhere(
                        (c) => c.id == val,
                      );
                    });
                  },
                ),
                const SizedBox(height: 25),
                const Text("Tags"),
                TagSelector(
                  tags: tagVM.tags,
                  selectedItems: selectedTags,
                  onChanged: (id) {
                    setState(() {
                      selectedTags[id!] = !(selectedTags[id] ?? false);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isSaving
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedCycle != null) {
                        setState(() => isSaving = true);

                        final selectedTagsList = tagVM.tags
                            .where((t) => selectedTags[t.id] ?? false)
                            .toList();

                        topicVM.insert(
                          Topic(
                            topicController.text,
                            selectedCycle!,
                            selectedTagsList,
                            studiedOn,
                          ),
                        );

                        context.go(AppRoutes.topics);
                        setState(() => isSaving = false);
                      } else {
                        // Mostra mensagem caso não tenha ciclo de revisão selecionado
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Por favor, selecione um ciclo de revisão antes de criar o tópico.",
                            ),
                          ),
                        );
                      }
                    }
                  },
            child: isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Criar Tópico"),
          ),
        ),
      ),
    );
  }
}
