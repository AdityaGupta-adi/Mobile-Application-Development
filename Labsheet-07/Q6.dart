import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  Database? database;
  List<Map<String, dynamic>> students = [];
  String message = 'Loading students...';

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q6_students.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE students ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT, rollNumber TEXT, course TEXT)',
        );

        await db.insert('students', {
          'name': 'Aditya',
          'rollNumber': '101',
          'course': 'BCA',
        });

        await db.insert('students', {
          'name': 'Rahul',
          'rollNumber': '102',
          'course': 'BCA',
        });

        await db.insert('students', {
          'name': 'Priya',
          'rollNumber': '103',
          'course': 'BCA',
        });
      },
    );

    await loadStudents();
  }

  Future<void> loadStudents() async {
    if (database == null) return;

    final result = await database!.query('students');

    if (mounted) {
      setState(() {
        students = result;
        message = students.isEmpty ? 'No students found' : '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Records'),
        actions: [
          IconButton(
            onPressed: loadStudents,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: students.isEmpty
          ? Center(child: Text(message))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${student['id']}'),
                    ),
                    title: Text(student['name'] ?? ''),
                    subtitle: Text(
                      'Roll No: ${student['rollNumber']}\n'
                      'Course: ${student['course']}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
