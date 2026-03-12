import 'package:looply/model/tag.dart';
import 'package:looply/repository/tag_repository.dart';
import 'package:looply/core/view_model/abstract_view_model.dart';

class TagViewModel extends AbstractViewModel<Tag, TagRepository> {

  final Tag defaultTag = Tag("Geral", id: 0);
  List<Tag> _tags = [];
  bool isLoading = true;

  TagViewModel(super.repository);

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Getter que sempre retorna a lista com defaultTag no início
  List<Tag> get tags => [defaultTag, ..._tags];

  // ============ METODOS ==============

  Future<void> loadTags() async {
    _setLoading(true);

    _tags = await repository.getAll();

    _setLoading(false);
  }

  Future<void> insert(Tag tag) async {
    await repository.insert(tag);
    await loadTags();
  }

  Future<void> update(Tag tag) async {
    if (tag.id != 0) {
      await repository.update(tag);
      await loadTags();
    }
    
  }

  Future<void> delete(int id) async{
    if (id != 0) {
      await repository.delete(id);
      await loadTags();
    }
  }

  Tag getDefault() {
    return defaultTag;
  }

  Future<List<Tag>> getAll() async {
    return await repository.getAll();
  }


  // NAÔ USADOS NO MOMENTO
  Future<Tag?> getById(int id) async {
    return await repository.getById(id);
  }

}