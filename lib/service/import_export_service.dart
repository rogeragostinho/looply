import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:looply/model/tag.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/repository/tag_repository.dart';
import 'package:looply/repository/topic_repository.dart';

class ImportExportService {
  final TagRepository _tagRepository;
  final TopicRepository _topicRepository;

  ImportExportService({
    required TagRepository tagRepository,
    required TopicRepository topicRepository,
  })  : _tagRepository = tagRepository,
        _topicRepository = topicRepository;

  // ─── EXPORTAR ───────────────────────────────────────────
  Future<String?> exportData() async {
  final tags = await _tagRepository.getAll();
  final topics = await _topicRepository.getAll();

  final data = {
    'version': 1,
    'exportedAt': DateTime.now().toIso8601String(),
    'tags': tags.map((t) => t.toJson()).toList(),
    'topics': topics.map((t) => t.toJson()).toList(),
  };

  final jsonBytes = utf8.encode(jsonEncode(data));

  final path = await FilePicker.platform.saveFile(
    dialogTitle: 'Guardar backup',
    fileName: 'looply_backup.json',
    type: FileType.custom,
    allowedExtensions: ['json'],
    bytes: jsonBytes,
  );

  if (path == null) return null; // utilizador cancelou

  // Garante que o ficheiro foi escrito (necessário em algumas plataformas)
  final file = File(path);
  if (!await file.exists()) {
    await file.writeAsBytes(jsonBytes);
  }

  return path;
}

  // ─── IMPORTAR ───────────────────────────────────────────
  Future<void> importData() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;

    if (data['version'] != 1) {
      throw Exception('Versão do ficheiro incompatível.');
    }

    final tags = (data['tags'] as List)
        .map((e) => Tag.fromJson(e as Map<String, dynamic>))
        .toList();

    final topics = (data['topics'] as List)
        .map((e) => Topic.fromJson(e as Map<String, dynamic>))
        .toList();

    for (final tag in tags) {
      await _tagRepository.insert(tag);
    }
    for (final topic in topics) {
      await _topicRepository.insert(topic);
    }
  }
}