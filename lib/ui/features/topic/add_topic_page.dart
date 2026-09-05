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
    FocusScope.of(context).unfocus();
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
    FocusScope.of(context).unfocus();

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
      // resizeToAvoidBottomInset continues true (the Scaffold default).
      // The actual fix is moving the button OUT of bottomNavigationBar
      // and into the body's own layout flow below — bottomNavigationBar
      // is a separate Scaffold slot that some navigation shells (nested
      // Scaffolds, IndexedStack tabs, etc.) don't reliably push above
      // the keyboard, which is why it was getting left behind.
      appBar: const AppTopBar(title: "Novo Tópico"),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  _SectionLabel(label: "Nome do tópico"),
                  const SizedBox(height: 8),
                  TopicTextField(controller: _topicController, label: "Tópico*"),

                  const SizedBox(height: 24),

                  _SectionLabel(label: "Data de estudo"),
                  const SizedBox(height: 8),
                  DatePickerField(
                    controller: _studiedOnController,
                    onTap: _selectDate,
                  ),

                  const SizedBox(height: 24),

                  _SectionLabel(label: "Ciclo de revisão"),
                  const SizedBox(height: 8),
                  RevisionCycleSelector(
                    onChanged: (value) =>
                        setState(() => _selectedRevisionCycle = value),
                    textController: _revisionCycleController,
                    selectedRevisionCycle: _selectedRevisionCycle,
                  ),

                  const SizedBox(height: 24),

                  _SectionLabel(label: "Tags"),
                  const SizedBox(height: 8),
                  TagSelector(
                    tags: tagVM.tags,
                    selectedItems: _selectedTags,
                    onChanged: (id) => setState(
                          () => _selectedTags[id!] = !(_selectedTags[id] ?? false),
                    ),
                  ),
                ],
              ),
            ),

            // Lives in the body's Column, so it always sits right above
            // the keyboard when it's open, and above the safe-area
            // bottom when it's closed — no separate slot to get lost
            // behind. No manual keyboard-inset math here: the Scaffold
            // (resizeToAvoidBottomInset defaults to true) already
            // shrinks this whole body above the keyboard, so adding
            // viewInsets.bottom again would double-count it and push
            // the button away from the keyboard instead of onto it.
            SafeArea(
              top: false,
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
          ],
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
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }
}