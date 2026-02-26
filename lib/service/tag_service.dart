import 'package:looply/repository/tag_repository.dart';

class TagService {
  var _repository;

  TagService._privateConstructor() {
    _repository = TagRepository();
  }

  static final TagService _instance = TagService._privateConstructor();

  static TagService get instance => _instance;

  void create(String name) {
    _repository.create()
  }
}