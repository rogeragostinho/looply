import 'package:looply/model/revision_cycle.dart';
import 'package:looply/repository/revision_cycle_repository.dart';
import 'package:looply/core/view_model/abstract_view_model.dart';

class RevisionCycleViewModel extends AbstractViewModel<RevisionCycle, RevisionCycleRepository> {

  final RevisionCycle defaultRevisonCycle = RevisionCycle("default", [1, 7, 30, 90], id: 0);
  List<RevisionCycle> _revisionCycles = [];
  bool isLoading = true;

  RevisionCycleViewModel(super.repository);

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  List<RevisionCycle> get revisionCycles => [defaultRevisonCycle, ..._revisionCycles];

  // ============ METODOS ==============

  Future<void> loadRevisionCycles() async {
    _setLoading(true);

    _revisionCycles = await repository.getAll();

    _setLoading(false);
  }

  Future<void> insert(RevisionCycle cycle) async {
    await repository.insert(cycle);
    await loadRevisionCycles();
  }

  Future<void> update(RevisionCycle cycle) async {
    if (cycle.id != 0) {
      await repository.update(cycle);
      await loadRevisionCycles();
    }
  }

  Future<RevisionCycle?> getById(int id) async {
    return await repository.getById(id);
  }

  Future<List<RevisionCycle>> getAll() async {
    return await repository.getAll();
  }

  RevisionCycle getDefault() {
    return defaultRevisonCycle;
  }

  Future<void> delete(int id) async {
    if (id != 0) {
      await repository.delete(id);
      await loadRevisionCycles();
    }
  }

}