class Note {
  String title;
  String content;

  Note(this.title, this.content);

  Map<String, dynamic> toJson() {
    return {
      'title':title,
      'content': content
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      json['title'],
      json['content']
    );
  }
}