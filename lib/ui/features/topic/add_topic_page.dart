import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/features/topic/widgets/topic_text_field.dart';
import 'package:looply/ui/features/topic/widgets/date_picker_field.dart';
import 'package:looply/ui/features/topic/widgets/revision_cycle_selector.dart';
import 'package:looply/ui/features/topic/widgets/tag_selector.dart';
import 'package:looply/viewmodel/tag_view_model.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:provider/provider.dart';
import 'package:looply/core/constants/topic_constants.dart';

class AddTopicPage extends StatefulWidget {
  const AddTopicPage({super.key});

  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _studiedOnController = TextEditingController();
  final _revisionCycleController = TextEditingController();

  DateTime _studiedOn = DateTime.now();
  String? _selectedRevisionCycle = TopicConstants.selectDefaultRevisionCycle;
  bool _isSaving = false;
  final Map<int, bool> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    _studiedOnController.text =
        '${_studiedOn.day}/${_studiedOn.month}/${_studiedOn.year}';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TagViewModel>().loadTags();
    });
  }

  @override
  void dispose() {
    _topicController.dispose();
    _studiedOnController.dispose();
    _revisionCycleController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _studiedOn,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _studiedOn = picked;
        _studiedOnController.text =
            '${_studiedOn.day}/${_studiedOn.month}/${_studiedOn.year}';
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRevisionCycle == null) {
      _showSnack("Por favor, selecione um ciclo de revisão antes de criar o tópico.");
      return;
    }

    List<int>? cycle;

    if (_selectedRevisionCycle == TopicConstants.selectDefaultRevisionCycle) {
      cycle = TopicConstants.defaultRevisionCycle;
    } else if (_selectedRevisionCycle == TopicConstants.selectOtherRevisionCycle) {
      if (_revisionCycleController.text.isEmpty) {
        _showSnack("Por favor, insira um ciclo de revisão antes de criar o tópico.");
        return;
      }
      cycle = _revisionCycleController.text
          .trim()
          .split(',')
          .map((e) => int.tryParse(e.trim()))
          .whereType<int>()
          .toList();
    }

    setState(() => _isSaving = true);

    final tagVM = context.read<TagViewModel>();
    final topicVM = context.read<TopicViewModel>();

    final selectedTagsList = tagVM.tags
        .where((t) => _selectedTags[t.id] ?? false)
        .toList();

    await topicVM.insert(
      Topic(_topicController.text, cycle!, selectedTagsList, _studiedOn),
    );

    if (mounted) {
      setState(() => _isSaving = false);
      context.go(AppRoutes.topics);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagVM = context.watch<TagViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const AppTopBar(title: "Novo Tópico"),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // ── Nome ──────────────────────────────────────
            _SectionLabel(label: "Nome do tópico"),
            const SizedBox(height: 8),
            TopicTextField(controller: _topicController, label: "Tópico*"),

            const SizedBox(height: 24),

            // ── Data de estudo ────────────────────────────
            _SectionLabel(label: "Data de estudo"),
            const SizedBox(height: 8),
            DatePickerField(
              controller: _studiedOnController,
              onTap: _selectDate,
            ),

            const SizedBox(height: 24),

            // ── Ciclo de revisão ──────────────────────────
            _SectionLabel(label: "Ciclo de revisão"),
            const SizedBox(height: 8),
            RevisionCycleSelector(
              onChanged: (value) =>
                  setState(() => _selectedRevisionCycle = value),
              textController: _revisionCycleController,
              selectedRevisionCycle: _selectedRevisionCycle,
            ),

            const SizedBox(height: 24),

            // ── Tags ──────────────────────────────────────
            _SectionLabel(label: "Tags"),
            const SizedBox(height: 8),
            TagSelector(
              tags: tagVM.tags,
              selectedItems: _selectedTags,
              onChanged: (id) => setState(
                () => _selectedTags[id!] = !(_selectedTags[id] ?? false),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton(
            onPressed: _isSaving ? null : _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _isSaving
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "Criar Tópico",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Widget auxiliar ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
    );
  }
}