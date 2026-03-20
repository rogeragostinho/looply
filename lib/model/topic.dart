import 'dart:convert';

import 'package:looply/model/note.dart';
import 'package:looply/model/revision.dart';
import 'package:looply/model/tag.dart';

class Topic {
  int? id;
  String name;
  List<int> revisionCycle;
  List<Tag> tags;
  DateTime studiedOn;
  List<Revision>? revisions;
  Note? note;
  List<String>? imagesUrl;

  Topic(
    this.name,
    this.revisionCycle,
    this.tags,
    this.studiedOn, {
    this.revisions,
    this.id,
    this.note,
    this.imagesUrl,
  });

  // =====================================
  // =============== JSON ================
  // =====================================
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id.toString(),
      'name': name,
      'studied_on': studiedOn.toIso8601String(),
      'revision_cycle_json': jsonEncode(revisionCycle),
      'tags_json': jsonEncode(tags.map((t) => t.toJson()).toList()),
      'note_json': note?.toJson() != null ? jsonEncode(note!.toJson()) : null,
      'revisions_json': revisions != null
          ? jsonEncode(revisions!.map((r) => r.toJson()).toList())
          : null,
      'images_url_json': imagesUrl != null ? jsonEncode(imagesUrl) : null,
    };
  }

  factory Topic.fromJson(Map<String, dynamic> map) {
    return Topic(
      map['name'],
      List<int>.from(jsonDecode(map['revision_cycle_json'])),
      (jsonDecode(map['tags_json']) as List)
          .map((e) => Tag.fromJson(e))
          .toList(),
      DateTime.parse(map['studied_on']),
      revisions: map['revisions_json'] != null
          ? (jsonDecode(map['revisions_json']) as List)
              .map((e) => Revision.fromJson(e))
              .toList()
          : null,
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      note: map['note_json'] != null
          ? Note.fromJson(jsonDecode(map['note_json']))
          : null,
      imagesUrl: map['images_url_json'] != null
          ? List<String>.from(jsonDecode(map['images_url_json']))
          : null,
    );
  }
}