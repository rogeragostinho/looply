import 'package:flutter/material.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
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

    if (topicVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtra tópicos pelas tags selecionadas (somente tags existentes)
    List filteredTopics = topicVM.topics.where((topic) {
      if (selectedTagIds.isEmpty) return true;

      final existingTagIds =
          topic.tags.where((t) => t.id != null).map((t) => t.id!).toList();

      return selectedTagIds.any((id) => existingTagIds.contains(id));
    }).toList();

    if (filteredTopics.isEmpty) {
      return Scaffold(
        appBar: const AppTopBar(title: "Tópicos"),
        body: const Center(child: Text("Nenhum tópico encontrado.")),
      );
    }

    return Scaffold(
      appBar: const AppTopBar(title: "Tópicos"),
      body: ListView.builder(
        itemCount: filteredTopics.length,
        itemBuilder: (context, index) {
          final topic = filteredTopics[index];
          return TopicCard(topic: topic);
        },
      ),
    );
  }
}