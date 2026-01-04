import 'dart:convert';

import 'package:looply/model/note.dart';
import 'package:looply/model/revision.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:looply/model/tag.dart';

class Topic {
  int id;
  String name;
  DateTime studiedOn;
  RevisionCycle revisionCycle;
  List<Tag> tags;
  Note? note;
  List<String>? imagesUrl;
  List<Revision> revisions;

  Topic(
    this.id,
    this.name,
    this.revisionCycle,
    this.tags,
    this.studiedOn,
    this.revisions, {
    this.note,
    this.imagesUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'studiedOn': studiedOn.toIso8601String(),

      'revision_cycle_json': jsonEncode(revisionCycle.toJson()),
      'tags_json': jsonEncode(tags.map((t) => t.toJson()).toList()),
      'note_json': note != null ? jsonEncode(note!.toJson()) : null,
      'revisions_json': jsonEncode(revisions.map((r) => r.toJson()).toList())
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      map['id'],
      map['name'],
      RevisionCycle.fromJson(jsonDecode(map['revision_cycle_json'])),
      (jsonDecode(map['tags_json']) as List)
        .map((e) => Tag.fromJson(e))
        .toList(),
      DateTime.parse(map['studied_on']),
      (jsonDecode(map['revisions_json']) as List)
        .map((e) => Revision.fromJson(e))
        .toList(),
      note: map['note_json'] != null 
        ? Note.fromJson(jsonDecode(map['note_json']))
        : null,
      imagesUrl: map['images_url_json'] != null
        ? List<String>.from(jsonDecode(map['images_url_json']))
        : null,
    );
  }
}

/*
Salvar no banco:
  String ciclosJson = jsonEncode(ciclos);
    "[1,7,30,90]"

Ler no banco:
  List<int> ciclos = List<int>.from(jsonDecode(ciclosJson));
*/
