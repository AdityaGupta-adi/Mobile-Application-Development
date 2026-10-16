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
      home: UpdateStudentScreen(),
    );
  }
}

class UpdateStudentScreen extends StatefulWidget {
  const UpdateStudentScreen({super.key});

  @override
  State<UpdateStudentScreen> createState() =>
      _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  final idController = TextEditingController(text: '1');
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final courseController = TextEditingController();

  Database? database;
  String message = 'Opening database...';

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q8_students.db');

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
      },
    );

    if (mounted) {
      setState(() {
        message = 'Database ready. Default student ID: 1';
      });
    }
  }

  Future<void> updateStudent() async {
    if (database == null) return;

    final id = int.tryParse(idController.text.trim());
    final name = nameController.text.trim();
    final roll = rollController.text.trim();
    final course = courseController.text.trim();

    if (id == null ||
        name.isEmpty ||
        roll.isEmpty ||
        course.isEmpty) {
      setState(() {
        message = 'Enter a valid ID and fill all fields.';
      });
      return;
    }

    final count = await database!.update(
      'students',
      {
        'name': name,
        'rollNumber': roll,
        'course': course,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    if (!mounted) return;

    setState(() {
      message = count > 0
          ? 'Student record updated successfully!'
          : 'No student found with ID $id.';
    });
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    rollController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student Record'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Student ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'New Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: rollController,
              decoration: const InputDecoration(
                labelText: 'New Roll Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'New Course',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: database == null ? null : updateStudent,
              child: const Text('Update Student'),
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
