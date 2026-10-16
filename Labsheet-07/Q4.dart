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
      home: StudentFormScreen(),
    );
  }
}

class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({super.key});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final courseController = TextEditingController();

  Database? database;
  String message = '';

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q4_students.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE students ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT, rollNumber TEXT, course TEXT)',
        );
      },
    );

    if (mounted) {
      setState(() {
        message = 'Database ready';
      });
    }
  }

  Future<void> saveStudent() async {
    if (database == null) return;

    final name = nameController.text.trim();
    final roll = rollController.text.trim();
    final course = courseController.text.trim();

    if (name.isEmpty || roll.isEmpty || course.isEmpty) {
      setState(() {
        message = 'Please fill in all fields.';
      });
      return;
    }

    await database!.insert('students', {
      'name': name,
      'rollNumber': roll,
      'course': course,
    });

    setState(() {
      message = 'Student record inserted successfully!';
    });

    nameController.clear();
    rollController.clear();
    courseController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student saved to SQLite database'),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: rollController,
              decoration: const InputDecoration(
                labelText: 'Roll Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: database == null ? null : saveStudent,
              child: const Text('Save Student'),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
