import 'dart:async';

Future<String> fetchStudentData() async {
  print('Fetching student data...');

  await Future.delayed(const Duration(seconds: 3));

  return 'Student data fetched successfully!';
}

Future<void> main() async {
  print('Program started');

  final result = await fetchStudentData();

  print(result);
  print('Program completed');
}
