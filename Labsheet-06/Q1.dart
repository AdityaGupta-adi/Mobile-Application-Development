import 'dart:io';

void main() {
  Map<String, String> student = {
    'Name': 'Aditya',
    'Roll Number': '101',
    'Course': 'BCA',
  };

  print('Student Details:');

  student.forEach((key, value) {
    print('$key: $value');
  });
}
