import 'package:flutter/material.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/features/tag/tag_view_model.dart';
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
    // Chama loadTopics apenas depois que o widget estiver montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TagViewModel>().loadTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TagViewModel tagVM = context.watch<TagViewModel>();

    if (tagVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tagVM.tags.isEmpty) {
      return const Center(child: Text("Nenhuma tag encontrada."));
    }

    return Scaffold(
      appBar: AppTopBar(title: "Tags"),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
            showDialog(context: context, builder: (context) => TagDialog()); // adicionar nova tag
          }, child: Text("Adicionar")),
          Expanded(
            child: ListView.builder(
              itemCount: tagVM.tags.length,
              itemBuilder: (context, index) {
                final tag = tagVM.tags[index];
              
                return Card(
                  child: Row(
                    children: [
                      Text("${tag.id} - ${tag.name}"),
                      ElevatedButton.icon(onPressed: () {
                         showDialog(context: context, builder: (context) => TagDialog(initialValue: tag.name, tagId: tag.id,));
                      }, label: Icon(Icons.edit)),
                      ElevatedButton.icon(onPressed: () {
                        tagVM.delete(tag.id!);
                      }, label: Icon(Icons.delete)),
                    ],
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}