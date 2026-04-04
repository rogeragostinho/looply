import 'package:flutter/material.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:provider/provider.dart';
import 'package:looply/ui/features/topic/widgets/topic_card.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  List<int> selectedTagIds = [];

  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();

    final filteredTopics = topicVM.topics.where((topic) {
      if (selectedTagIds.isEmpty) return true;
      final existingTagIds = topic.tags
          .where((t) => t.id != null)
          .map((t) => t.id!)
          .toList();
      return selectedTagIds.any((id) => existingTagIds.contains(id));
    }).toList();

    return Scaffold(
      appBar: const AppTopBar(title: "Tópicos"),
      body: topicVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredTopics.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.layers_outlined,
                    size: 56,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.25),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Nenhum tópico encontrado.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: filteredTopics.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == filteredTopics.length) {
                  return const SizedBox(height: 56);
                }
                return TopicCard(topic: filteredTopics[index]);
              },
            ),
    );
  }
}
