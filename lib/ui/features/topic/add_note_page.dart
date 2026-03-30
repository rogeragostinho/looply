import 'package:flutter/material.dart';
import 'package:looply/model/note.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/ui/features/topic/args/add_note_args.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
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

    if (widget.args.editMode) {
      topic.note!.title = _titleController.text;
      topic.note!.content = _contentController.text;
    } else {
      topic.note = Note(_titleController.text, _contentController.text);
    }

    topicVM.update(topic);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();

    return Scaffold(
      appBar: AppTopBar(
        title: widget.args.editMode ? "Editar Nota" : "Adicionar Nota",
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Por favor, insira Título" : null,
              ),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: "Conteúdo"),
                  maxLines: null,
                  expands: true,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Por favor, insira Conteúdo" : null,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text("CANCELAR"),
            ),
            ElevatedButton(
              onPressed: () => _save(topicVM),
              child: const Text("SALVAR"),
            ),
          ],
        ),
      ),
    );
  }
}