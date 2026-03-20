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
import 'package:looply/ui/features/tag/tag_view_model.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:provider/provider.dart';
import 'package:looply/core/constants/topic_constants.dart';

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
  bool isSaving = false;
  final Map<int, bool> selectedTags = {};

  // ** TEMP **
  String? _selectRevisionCycle = "default";
  final revisionCycleController = TextEditingController();
  //

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Carrega dados
      final tagVM = context.read<TagViewModel>();
      
      tagVM.loadTags();

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

                Text(_selectRevisionCycle ?? ""),
                RevisionCycleSelector(
                  onChanged: (String? value) {
                    setState(() {
                      _selectRevisionCycle = value;  
                    });
                  }, 
                  textController: revisionCycleController, 
                  selectedRevisionCycle: _selectRevisionCycle
                ),

                /*RevisionCycleSelector(
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
                ),*/
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
                      if (_selectRevisionCycle != null) { //retirar depois
                        setState(() => isSaving = true);

                        final selectedTagsList = tagVM.tags
                            .where((t) => selectedTags[t.id] ?? false)
                            .toList();

                        List<int>? cycle;

                        if (_selectRevisionCycle == TopicConstants.selectDefaultRevisionCycle) {
                          cycle = TopicConstants.defaultRevisionCycle;
                        } else if (_selectRevisionCycle == TopicConstants.selectOtherRevisionCycle) {
                          final cycleText = revisionCycleController.text.trim();
                          cycle = cycleText
                            .split(',')
                            .map((e) => int.tryParse(e.trim()))
                            .whereType<int>()
                            .toList();
                        }

                        topicVM.insert(
                          Topic(
                            topicController.text,
                            cycle!,
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
