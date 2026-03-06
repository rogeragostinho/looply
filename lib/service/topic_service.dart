import 'package:looply/model/revision.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/service/abstract_service.dart';
import '../core/enums/revision_status.dart';

class TopicService extends AbstractService<Topic, TopicRepository> {

  TopicService._privateConstructor() : super(TopicRepository.instance);

  // ============ SINGLETON ===============
  static final TopicService _instance = TopicService._privateConstructor();
  static TopicService get instance => _instance;
  // =====================================

  // ============ METODOS ==============
  /*Future<void> create({
    required String name,
    required DateTime studiedOn,
    required RevisionCycle revisionCycle,
    required List<Tag> tags,
  }) async {
    final revisions = revisionCycle.cycle
        .map(
          (days) => Revision(
            date: studiedOn.add(Duration(days: days)),
            status: RevisionStatus.upComing,
          ),
        )
        .toList();

    await repository.insert(
      Topic(name, revisionCycle, tags, studiedOn, revisions),
    );
  }*/

  @override
  Future<int> insert(Topic topic) async {
    final revisions = topic.revisionCycle.cycle
        .map(
          (days) => Revision(
            date: topic.studiedOn.add(Duration(days: days)),
            status: RevisionStatus.upComing,
          ),
        )
        .toList();

    topic.revisions = revisions;

    return await repository.insert(topic);
  }

  @override
  Future<int> update(Topic topic) async {
    return await repository.update(topic);
  }

  @override
  Future<List<Topic>> getAll() async {
    return await repository.getAll();
  }

  @override
  Future<int> delete(int id) async {
    return await repository.delete(id);
  }

  @override
  Future<Topic?> getById(int id) async {
    return await repository.getById(id);
  }

}
