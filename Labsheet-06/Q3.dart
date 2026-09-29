import 'dart:convert';

void main() {
  Map<String, dynamic> student = {
    'name': 'Aditya',
    'rollNumber': '101',
    'course': 'BCA',
  };

  // Map to JSON
  String jsonString = jsonEncode(student);

  print('Map converted to JSON:');
  print(jsonString);

  // JSON to Map
  Map<String, dynamic> newStudent = jsonDecode(jsonString);

  print('\nJSON converted back to Map:');
  print(newStudent);
}
