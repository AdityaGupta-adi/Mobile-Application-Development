import 'dart:convert';

class Student {
  final int id;
  final String name;
  final String course;

  Student({
    required this.id,
    required this.name,
    required this.course,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      course: json['course'] as String,
    );
  }

  void display() {
    print('ID: $id');
    print('Name: $name');
    print('Course: $course');
    print('----------------------');
  }
}

void main() {
  const jsonData = '''
  [
    {"id": 1, "name": "Aditya", "course": "BCA"},
    {"id": 2, "name": "Rahul", "course": "BCA"},
    {"id": 3, "name": "Priya", "course": "MCA"}
  ]
  ''';

  final List<dynamic> decodedData = jsonDecode(jsonData);

  final List<Student> students = decodedData
      .map((item) => Student.fromJson(item as Map<String, dynamic>))
      .toList();

  for (final student in students) {
    student.display();
  }
}
