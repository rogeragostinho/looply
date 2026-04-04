import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/core/enums/revision_status.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/features/topic/args/add_note_args.dart';
import 'package:looply/ui/features/topic/args/view_image%20args.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:looply/ui/features/topic/widgets/topic_name_dialog.dart';
import 'package:provider/provider.dart';

class TopicDetailsPage extends StatelessWidget {
  const TopicDetailsPage({super.key, required this.topicId});

  final int topicId;

  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();
    final topic = topicVM.getById(topicId);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (topic == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Tópico")),
        body: const Center(child: Text("Tópico não encontrado.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: "Editar nome",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TopicNameDialog(topic: topic),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // ── Nome + Tags ─────────────────────────────────────
          Text(
            topic.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (topic.tags.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: topic.tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag.name),
                      labelStyle: theme.textTheme.labelSmall,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            )
          else
            Text(
              "Sem tags",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),

          const SizedBox(height: 24),

          // ── Revisões ────────────────────────────────────────
          _SectionHeader(label: "Linha do tempo de revisões"),
          const SizedBox(height: 12),
          ...topic.revisions!.asMap().entries.map((entry) {
            final i = entry.key;
            final revision = entry.value;
            final isLast = i == topic.revisions!.length - 1;

            final day = revision.date.day.toString().padLeft(2, '0');
            final month = revision.date.month.toString().padLeft(2, '0');
            final year = revision.date.year;

            late String statusLabel;
            late Color dotColor;
            late IconData statusIcon;

            switch (revision.status) {
              case RevisionStatus.done:
                statusLabel = "Feito";
                dotColor = Colors.green;
                statusIcon = Icons.check_circle_rounded;
                break;
              case RevisionStatus.pending:
                statusLabel = "Pendente";
                dotColor = Colors.orange;
                statusIcon = Icons.schedule_rounded;
                break;
              default:
                statusLabel = "Por vir";
                dotColor = colorScheme.onSurface.withOpacity(0.3);
                statusIcon = Icons.radio_button_unchecked_rounded;
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // linha vertical + ponto
                  SizedBox(
                    width: 32,
                    child: Column(
                      children: [
                        Icon(statusIcon, color: dotColor, size: 20),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$day/$month/$year",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          statusLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: dotColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),

          // ── Nota ────────────────────────────────────────────
          _SectionHeader(label: "Nota"),
          const SizedBox(height: 12),

          topic.note == null
              ? _EmptyCard(
                  icon: Icons.sticky_note_2_outlined,
                  label: "Nenhuma nota adicionada",
                  buttonLabel: "Adicionar nota",
                  onPressed: () {
                    context.push(
                      AppRoutes.topicAddNote,
                      extra: AddNoteArgs(topicId: topicId, editMode: false),
                    );
                  },
                )
              : Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                topic.note!.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () {
                                context.push(
                                  AppRoutes.topicAddNote,
                                  extra: AddNoteArgs(
                                    topicId: topicId,
                                    editMode: true,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: colorScheme.error,
                              ),
                              onPressed: () {
                                topic.note = null;
                                topicVM.update(topic);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topic.note!.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.75),
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

          const SizedBox(height: 24),

          // ── Imagens ─────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionHeader(label: "Imagens"),
              TextButton.icon(
                onPressed: () => topicVM.addImage(topic),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Adicionar"),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (topic.imagesUrl == null || topic.imagesUrl!.isEmpty)
            _EmptyCard(
              icon: Icons.image_outlined,
              label: "Nenhuma imagem adicionada",
              buttonLabel: "Adicionar imagem",
              onPressed: () => topicVM.addImage(topic),
            )
          else
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: topic.imagesUrl!.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final imgPath = topic.imagesUrl![index];
                  return GestureDetector(
                    onTap: () {
                      context.push(
                        AppRoutes.topicViewImage,
                        extra: ViewImageArgs(
                          topicId: topicId,
                          imageIndex: index,
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(imgPath),
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── Widgets auxiliares ───────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

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

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _EmptyCard({
    required this.icon,
    required this.label,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onSurface.withOpacity(0.3), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.45),
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}