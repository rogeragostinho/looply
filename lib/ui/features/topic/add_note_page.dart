import 'package:flutter/material.dart';
import 'package:looply/model/note.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/ui/features/topic/args/add_note_args.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:provider/provider.dart';
 
class AddNotePage extends StatefulWidget {
  final AddNoteArgs args;
 
  const AddNotePage({super.key, required this.args});
 
  @override
  State<AddNotePage> createState() => _AddNotePageState();
}
 
class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
 
  @override
  void initState() {
    super.initState();
    final topic = context.read<TopicViewModel>().getById(widget.args.topicId);
    _titleController = TextEditingController(
      text: widget.args.editMode ? topic?.note?.title ?? "" : "",
    );
    _contentController = TextEditingController(
      text: widget.args.editMode ? topic?.note?.content ?? "" : "",
    );
  }
 
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
 
  void _save(TopicViewModel topicVM) {
    if (!_formKey.currentState!.validate()) return;
    final topic = topicVM.getById(widget.args.topicId);
    if (topic == null) return;
    topic.note = Note(_titleController.text, _contentController.text);
    topicVM.update(topic);
    context.pop();
  }
 
  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
 
    return Scaffold(
      appBar: AppTopBar(
        title: widget.args.editMode ? "Editar Nota" : "Adicionar Nota",
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value == null || value.isEmpty
                    ? "Por favor, insira o título"
                    : null,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: "Conteúdo",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) => value == null || value.isEmpty
                      ? "Por favor, insira o conteúdo"
                      : null,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text("Cancelar"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => _save(topicVM),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Guardar",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}