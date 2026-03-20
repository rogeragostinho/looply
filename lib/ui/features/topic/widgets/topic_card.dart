import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/model/revision.dart';
import 'package:looply/core/enums/revision_status.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:provider/provider.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;

  const TopicCard({super.key, required this.topic});

  Color _statusColor(RevisionStatus status) {
    switch (status) {
      case RevisionStatus.pending:
        return Colors.orange;
      case RevisionStatus.done:
        return Colors.green;
      case RevisionStatus.upComing:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topicVM = context.read<TopicViewModel>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com nome e botão deletar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    topic.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => topicVM.delete(topic.id!),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Data de estudo
            Text(
              "Data de estudo: ${topic.studiedOn.day}/${topic.studiedOn.month}/${topic.studiedOn.year}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            // Revisões
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: topic.revisions!.map((r) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(r.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${r.date.day}/${r.date.month} - ${r.status.name}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            // Tags
            Wrap(
              spacing: 6,
              children: topic.tags
                  .map((t) => Chip(
                        label: Text(t.name),
                        backgroundColor: Colors.blue.shade100,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}