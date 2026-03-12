import 'package:looply/model/revision.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/core/view_model/abstract_view_model.dart';
import '../../../core/enums/revision_status.dart';

class TopicViewModel extends AbstractViewModel<Topic, TopicRepository> {
  List<Topic> topics = [];
  bool isLoading = true;

  TopicViewModel(super.repository);

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // ============ METODOS ==============
  Future<void> loadTopics() async {
    _setLoading(true);
    topics = await repository.getAll();
    _setLoading(false);
  }

  void insert(Topic topic) async {
    final revisions = topic.revisionCycle.cycle
        .map(
          (days) => Revision(
            date: topic.studiedOn.add(Duration(days: days)),
            status: RevisionStatus.upComing,
          ),
        )
        .toList();

    topic.revisions = revisions;

    await repository.insert(topic);

    // atualiza a lista após inserir
    await loadTopics();
  }

  Future<void> update(Topic topic) async {
    await repository.update(topic);

    await loadTopics();
  }

  Future<List<Topic>> getAll() async {
    return await repository.getAll();
  }

  Future<void> delete(int id) async {
    await repository.delete(id);

    await loadTopics();
  }

  Topic? getTopicById(int id) {
    return topics.firstWhere((t) => t.id == id);
  }

}
