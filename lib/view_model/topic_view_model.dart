import 'package:looply/model/revision.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/view_model/abstract_view_model.dart';
import '../core/enums/revision_status.dart';

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

  @override
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

  @override
  Future<int> update(Topic topic) async {
    return await repository.update(topic);
  }

  @override
  Future<List<Topic>> getAll() async {
    isLoading = true;
    notifyListeners();

    //return await repository.getAll();
    final result = await repository.getAll();
    
    isLoading = false;
    notifyListeners();
    return result;
  }

  @override
  Future<int> delete(int id) async {
    return await repository.delete(id);
  }

  @override
  Future<Topic?> getById(int id) async {
    return await repository.getById(id);
  }

  Topic? getTopicById(int id) {
    return topics.firstWhere((t) => t.id == id);
  }

}
