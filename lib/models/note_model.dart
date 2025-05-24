class Note {
  Note({
    required this.id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastModifiedAt = createdAt ?? DateTime.now();

  final String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime lastModifiedAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'lastModifiedAt': lastModifiedAt,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: map['createdAt'],
      lastModifiedAt: map['lastModifiedAt'],
    );
  }

  Note copyWith({String? title, String? content}) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      lastModifiedAt: DateTime.now(),
    );
  }
}
