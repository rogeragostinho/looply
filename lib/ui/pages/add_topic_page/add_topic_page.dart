import 'package:flutter/material.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:looply/model/tag.dart';
import 'package:looply/service/revision_cycle_service.dart';
import 'package:looply/service/tag_service.dart';
import 'package:looply/service/topic_service.dart';
import 'package:looply/ui/core/app_state.dart';
import 'package:provider/provider.dart';

class AddTopicPage extends StatefulWidget {
  const AddTopicPage({super.key});

  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final formTopicController = TextEditingController();
  final formStudiedOnController = TextEditingController();
  //int? idRevisionCycle = RevisionCycleService.instance.get(1).id;
  DateTime studiedOn = DateTime.now();
  int? selectedRevisionCycleId;
  RevisionCycle? selectedRevisionCycle;

  bool _isSaving = false; // para o botão Create Topic

  final Map<int, bool> selectedItems = {};

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    setState(() {
      if (pickedDate != null) {
        studiedOn = pickedDate;
        formStudiedOnController.text =
            '${studiedOn.day}/${studiedOn.month}/${studiedOn.year}';

        //formStudiedOnController.text  studiedOn.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final appState = context.read<AppState>();
    appState.getRevisionCycles();
    appState.getTags();

    formStudiedOnController.text =
        '${studiedOn.day}/${studiedOn.month}/${studiedOn.year}';

    /*for (var item in items) {
      selectedItems[item['id']] = false;
    }*/
  }

  @override
  void dispose() {
    formTopicController.dispose();
    formStudiedOnController.dispose();
    super.dispose();
  }

  String color = "amber";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    List<RevisionCycle>? revisionCycles = [];
    revisionCycles.add(RevisionCycleService.instance.getDefault());
    revisionCycles.addAll(appState.revisionCycles);

    //List<Tag?> tags = appState.tags ?? [];
    List<Tag?> tags = [];
    tags.add(TagService.instance.getDefault());
    tags.addAll(appState.tags);


    return Scaffold(
      appBar: AppBar(
        title: Text("Add Topic"),
        backgroundColor: Color(Colors.blue.toARGB32()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: formTopicController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Topic*"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira o tópico";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 25.0),

                TextFormField(
                  readOnly: true,
                  controller: formStudiedOnController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "StudiedOn",
                    suffixIcon: IconButton(
                      onPressed: _selectDate,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira a data";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 25.0),
                Text("Revision Cycle"),

                // Substitua todo o bloco do "if (revisionCycles == null) ... else" por este:
                if (revisionCycles == null)
                  const Center(child: CircularProgressIndicator())
                else
                  RadioGroup<int>(
                    // O parâmetro correto para o estado atual no RadioGroup é groupValue
                    groupValue: selectedRevisionCycleId,
                    onChanged: (int? val) {
                      setState(() {
                        selectedRevisionCycleId = val;
                        selectedRevisionCycle = revisionCycles.firstWhere(
                          (t) => t.id == val,
                        );
                      });
                    },
                    child: Column(
                      children: revisionCycles.map((revision) {
                        return RadioListTile<int>(
                          value: revision.id!,
                          title: Text("${revision.name} ${revision.cycle}"),
                          // Aqui dentro você NÃO coloca groupValue nem onChanged,
                          // pois o RadioGroup pai já cuida disso.
                        );
                      }).toList(),
                    ),
                  ),

                SizedBox(height: 25.0),

                //TAGS
                Text("Tags for you topic"),
                ElevatedButton(
                  onPressed: () => {},
                  child: Text("Criar nova Tag"),
                ),
                Column(
                  children: (tags ?? []).map((item) {
                    if (item == null)
                      return SizedBox.shrink(); // pula itens nulos
                    int id = item.id!;
                    String name = item.name ?? '';

                    return CheckboxListTile(
                      title: Text(name),
                      value: selectedItems[id] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedItems[id] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),

                SizedBox(height: 6.0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
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
            // Se _isSaving for true, onPressed recebe null (botão fica cinza/desativado)
            onPressed: _isSaving
                ? null
                : () async {
                    if (_formKey.currentState!.validate() &&
                        selectedRevisionCycle != null) {
                      setState(() => _isSaving = true);

                      try {
                        // Filtra as tags selecionadas transformando o Map em uma List<Tag>
                        final selectedTagsList = (appState.tags ?? [])
                            .whereType<
                              Tag
                            >() // Remove nulos e tipa corretamente
                            .where((tag) => selectedItems[tag.id] == true)
                            .toList();

                        await TopicService.instance.create(
                          name: formTopicController.text,
                          studiedOn: studiedOn,
                          revisionCycle: selectedRevisionCycle!,
                          tags: selectedTagsList,
                        );

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        // É bom capturar erros de banco de dados para não travar o botão em loading
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erro ao salvar: $e")),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isSaving = false);
                      }
                    } else if (selectedRevisionCycle == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Por favor, selecione um ciclo de revisão",
                          ),
                        ),
                      );
                    }
                  },
            child: _isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Create Topic"),
          ),
        ),
      ),
    );
  }
}
