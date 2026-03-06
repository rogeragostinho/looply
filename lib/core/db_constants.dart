class DBTables {
  static const topics = 'tbl_topics';
  static const revisionCycle = 'tbl_revision_cycle';
  static const tags = 'tbl_tags';
}

class TopicsColumns {
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colRevisionCycle = 'revision_cycle_json';
  static const String colTags = 'tags_json';
  static const String colNote = 'note_json';
  static const String colRevisions = 'revisions_json';
}

class RevisionCycleColumns {
  static const String colId= 'id';
  static const String colName = 'name';
  static const String colCycle= 'cycle_json';
}

class TagsColumns {
  static const String colId= 'id';
  static const String colName = 'name';
}