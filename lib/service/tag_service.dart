import 'package:looply/model/tag.dart';
import 'package:looply/repository/tag_repository.dart';
import 'package:looply/service/abstract_service.dart';

class TagService extends AbstractService<Tag, TagRepository> {

  Tag defaultTag = Tag("Geral", id: 0);

  TagService._privateConstructor() : super(TagRepository.instance);

  // ============ SINGLETON ===============
  static final TagService _instance = TagService._privateConstructor();
  static TagService get instance => _instance;
  // =====================================

  // ============ METODOS ==============
  void create(String name) {
    repository.insert(Tag(name));
  }

  Future<Tag?> get(int id) async {
    return await repository.getById(0);
  }

  Tag getDefault() {
    return defaultTag;
  }

  Future<List<Tag>> getAll() async {
    return await repository.getAll();
  }

  void delete(int id) async{
    await repository.delete(id);
  }
}