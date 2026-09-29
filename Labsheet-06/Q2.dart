class Student {
  String name;
  String rollNumber;
  String course;

  Student({
    required this.name,
    required this.rollNumber,
    required this.course,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rollNumber': rollNumber,
      'course': course,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'],
      rollNumber: map['rollNumber'],
      course: map['course'],
    );
  }
}

void main() {
  Student student = Student(
    name: 'Aditya',
    rollNumber: '101',
    course: 'BCA',
  );

  Map<String, dynamic> studentMap = student.toMap();

  print('Student Object converted to Map:');
  print(studentMap);

  Student newStudent = Student.fromMap(studentMap);

  print('\nMap converted back to Student:');
  print('Name: ${newStudent.name}');
  print('Roll Number: ${newStudent.rollNumber}');
  print('Course: ${newStudent.course}');
}
