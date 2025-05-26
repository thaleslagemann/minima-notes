import 'package:flutter/widgets.dart';

class Note {
  Note({
    required this.uuid,
    required this.title,
    required this.content,
    this.icon,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastUpdatedAt = createdAt ?? DateTime.now();

  final String uuid;
  String title;
  String content;
  IconData? icon;
  DateTime createdAt;
  DateTime lastUpdatedAt;

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'content': content,
      'icon': icon,
      'createdAt': createdAt,
      'lastUpdatedAt': lastUpdatedAt,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      uuid: map['uuid'],
      title: map['title'],
      content: map['content'],
      icon: map['icon'],
      createdAt: map['createdAt'],
      lastUpdatedAt: map['lastUpdatedAt'],
    );
  }

  Note copyWith({String? title, String? content, IconData? icon}) {
    return Note(
      uuid: uuid,
      title: title ?? this.title,
      content: content ?? this.content,
      icon: icon ?? this.icon,
      createdAt: createdAt,
      lastUpdatedAt: DateTime.now(),
    );
  }
}
