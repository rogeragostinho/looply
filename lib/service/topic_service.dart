import 'package:looply/model/revision.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:looply/model/tag.dart';
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
  Future<void> create({
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
  }

  Future<List<Topic>> getAll() async {
    return await repository.getAll();
  }

  Future<int> delete(int id) async {
    return await repository.delete(id);
  }

  /*Topic get(int id) {
    return list.elementAt(id);
  }

  void remove(int id) {
    list.removeAt(id);
  }

  void removeAll() {
  list = [];
}*/
}
