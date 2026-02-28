import 'package:looply/model/tag.dart';
import 'package:looply/repository/tag_repository.dart';

class TagService {
  var _repository;

  TagService._privateConstructor() {
    _repository = TagRepository();
  }

  static final TagService _instance = TagService._privateConstructor();

  static TagService get instance => _instance;

  void create(String name) {
    _repository.create(Tag(name));
  }

  Future<Tag?> get(int id) async {
    return await _repository.getById();
  }

  Future<List<Tag>> getAll() async {
    return await _repository.getAll();
  }

  void delete(int id) async{
    await _repository.delete(id);
  }
}