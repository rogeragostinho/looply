import 'package:looply/model/revision_cycle.dart';
import 'package:looply/repository/revision_cycle_repository.dart';
import 'package:looply/view_model/abstract_view_model.dart';

class RevisionCycleViewModel extends AbstractViewModel<RevisionCycle, RevisionCycleRepository> {

  List<RevisionCycle> list = [];
  final RevisionCycle defaultRevisonCycle = RevisionCycle("default", [1, 7, 30, 90], id: 0);

  RevisionCycleViewModel(super.repository) {
    list.add(RevisionCycle("Default", [1, 7, 30, 60]));
  }

  // ============ METODOS ==============
  @override
  Future<int> insert(RevisionCycle cycle) async {
    return await repository.insert(cycle);
  }

  @override
  Future<int> update(RevisionCycle cycle) async {
    return await repository.update(cycle);
  }

  @override
  Future<RevisionCycle?> getById(int id) async {
    return await repository.getById(id);
  }

  @override
  Future<List<RevisionCycle>> getAll() async {
    return await repository.getAll();
  }


  RevisionCycle getDefault() {
    return defaultRevisonCycle;
  }

  @override
  Future<int> delete(int id) async {
    return await repository.delete(id);
  }

}