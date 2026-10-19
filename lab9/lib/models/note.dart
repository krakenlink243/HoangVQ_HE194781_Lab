/// Item saved in `<documents>/notes.json` (Lab 9.2).
class Note {
  final int id;
  final String text;
  final DateTime createdAt;

  const Note({required this.id, required this.text, required this.createdAt});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as int,
    text: json['text'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
  };
}
