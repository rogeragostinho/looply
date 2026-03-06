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
  @override
  Future<int> insert(Tag tag) async {
    return await repository.insert(tag);
  }

  @override
  Future<int> update(Tag tag) async {
    return await repository.update(tag);
  }

  @override
  Future<Tag?> getById(int id) async {
    return await repository.getById(id);
  }

  Tag getDefault() {
    return defaultTag;
  }

  @override
  Future<List<Tag>> getAll() async {
    return await repository.getAll();
  }

  @override
  Future<int> delete(int id) async{
    return await repository.delete(id);
  }
}