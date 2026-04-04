import 'package:flutter/material.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/core/widgets/confirm_dialog.dart';
import 'package:looply/viewmodel/tag_view_model.dart';
import 'package:looply/ui/features/tag/widgets/tag_dialog.dart';
import 'package:provider/provider.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TagViewModel>().loadTags();
    });
  }

  void _openDialog(BuildContext context, {String? initialValue, int? tagId}) {
    showDialog(
      context: context,
      builder: (context) => TagDialog(initialValue: initialValue, tagId: tagId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagVM = context.watch<TagViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppTopBar(
        title: "Tags",
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nova tag",
            onPressed: () => _openDialog(context),
          ),
        ],
      ),
      body: tagVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : tagVM.tags.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.label_outline,
                        size: 56,
                        color: colorScheme.onSurface.withOpacity(0.25),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Nenhuma tag encontrada.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.45),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.tonal(
                        onPressed: () => _openDialog(context),
                        child: const Text("Criar primeira tag"),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  itemCount: tagVM.tags.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final tag = tagVM.tags[index];

                    return Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.label_rounded,
                              size: 18,
                              color: colorScheme.primary.withOpacity(0.7),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tag.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (tag.id != 0) ...[
                              IconButton(
                                icon: Icon(
                                  Icons.edit_outlined,
                                  size: 20,
                                  color:
                                      colorScheme.onSurface.withOpacity(0.5),
                                ),
                                onPressed: () => _openDialog(
                                  context,
                                  initialValue: tag.name,
                                  tagId: tag.id,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: colorScheme.error.withOpacity(0.7),
                                ),
                                onPressed: () async {
                                  final confirmed = await ConfirmDialog.show(
                                    context,
                                    title: "Eliminar Tag",
                                    isDanger: true,
                                  );
                                  if (!confirmed) return;
                                  tagVM.delete(tag.id!);
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}