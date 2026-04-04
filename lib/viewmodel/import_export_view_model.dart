import 'package:flutter/material.dart';
import 'package:looply/service/import_export_service.dart';

enum ImportExportStatus { idle, loading, success, error }

class ImportExportViewModel extends ChangeNotifier {
  final ImportExportService _service;

  ImportExportViewModel(this._service);

  ImportExportStatus status = ImportExportStatus.idle;
  String? errorMessage;
  String? exportedPath;

  // ─── EXPORTAR ───────────────────────────────────────────
  Future<void> exportData() async {
  _setStatus(ImportExportStatus.loading);
  try {
    exportedPath = await _service.exportData();

    if (exportedPath == null) {
      _setStatus(ImportExportStatus.idle); // utilizador cancelou, não é erro
      return;
    }

    _setStatus(ImportExportStatus.success);
  } catch (e) {
    errorMessage = e.toString();
    _setStatus(ImportExportStatus.error);
  }
}

  // ─── IMPORTAR ───────────────────────────────────────────
  Future<void> importData() async {
  _setStatus(ImportExportStatus.loading);
  try {
    await _service.importData();
    _setStatus(ImportExportStatus.success);
  } catch (e) {
    if (e is FilePickerCancelledException) { // se o teu FilePicker lançar excepção ao cancelar
      _setStatus(ImportExportStatus.idle);
      return;
    }
    errorMessage = e.toString();
    _setStatus(ImportExportStatus.error);
  }
}

  void reset() {
    status = ImportExportStatus.idle;
    errorMessage = null;
    exportedPath = null;
    notifyListeners();
  }

  void _setStatus(ImportExportStatus s) {
    status = s;
    notifyListeners();
  }
}

mixin FilePickerCancelledException {
}