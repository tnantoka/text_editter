import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Note {
  Note({id, required this.name, this.text = '', createdAt, updatedAt})
      : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? DateTime.now().toUtc();

  final String id;
  final String name;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note copyWith({
    String? name,
    String? text,
  }) =>
      Note(
        id: id,
        name: name ?? this.name,
        text: text ?? this.text,
        createdAt: createdAt,
        updatedAt: DateTime.now().toUtc(),
      );

  Note.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        text = json['text'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']);

  Map<String, String> toJson() => {
        'id': id,
        'name': name,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
