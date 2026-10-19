/// Record of the local mini-database `<documents>/students.json` (Lab 9.3).
class Student {
  final int id;
  final String name;
  final String major;
  final double gpa;

  const Student({
    required this.id,
    required this.name,
    required this.major,
    required this.gpa,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json['id'] as int,
    name: json['name'] as String,
    major: json['major'] as String,
    // JSON numbers may come back as int (e.g. 3) or double (e.g. 3.5).
    gpa: (json['gpa'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'major': major,
    'gpa': gpa,
  };

  Student copyWith({String? name, String? major, double? gpa}) => Student(
    id: id,
    name: name ?? this.name,
    major: major ?? this.major,
    gpa: gpa ?? this.gpa,
  );
}
