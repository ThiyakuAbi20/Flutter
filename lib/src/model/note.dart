// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Note {
  int? id; // Use nullable for manual management of the primary key
  final String title;
  final String description;
  final DateTime lastMod;

  Note({
    this.id, // id can be null for auto-increment behavior
    required this.title,
    required this.description,
    required this.lastMod,
  });

  Note copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? lastMod,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      lastMod: lastMod ?? this.lastMod,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id, // id can be null here for auto-increment
      'title': title,
      'description': description,
      'lastMod': lastMod.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?, // Parse id as int?
      title: map['title'] as String,
      description: map['description'] as String,
      lastMod: DateTime.fromMillisecondsSinceEpoch(map['lastMod'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Note(id: $id, title: $title, description: $description, lastMod: $lastMod)';
  }

  @override
  bool operator ==(covariant Note other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.lastMod == lastMod;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      lastMod.hashCode;
  }
}
