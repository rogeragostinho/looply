import 'package:flutter/material.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/core/widgets/confirm_dialog.dart';
import 'package:looply/ui/features/tag/tag_view_model.dart';
import 'package:looply/ui/features/tag/widgets/tag_dialog.dart';
import 'package:looply/ui/features/topic/widgets/custom_card.dart';
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
      appBar: AppTopBar(
        title: "Tags",
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TagDialog(),
              ); // adicionar nova tag
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: tagVM.tags.length,
              itemBuilder: (context, index) {
                final tag = tagVM.tags[index];

                return CustomCard(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${tag.name}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight(500),
                          ),
                        ),
                        Spacer(),
                        if (tag.id != 0) ...[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => TagDialog(
                                  initialValue: tag.name,
                                  tagId: tag.id,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
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
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
