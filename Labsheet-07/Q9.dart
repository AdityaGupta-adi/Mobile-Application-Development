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
      home: DeleteStudentScreen(),
    );
  }
}

class DeleteStudentScreen extends StatefulWidget {
  const DeleteStudentScreen({super.key});

  @override
  State<DeleteStudentScreen> createState() =>
      _DeleteStudentScreenState();
}

class _DeleteStudentScreenState extends State<DeleteStudentScreen> {
  final idController = TextEditingController(text: '1');

  Database? database;
  String message = 'Opening database...';

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q9_students.db');

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
          'course': 'MCA',
        });
      },
    );

    if (mounted) {
      setState(() {
        message = 'Database ready. Sample records added.';
      });
    }
  }

  Future<void> deleteStudent() async {
    if (database == null) return;

    final id = int.tryParse(idController.text.trim());

    if (id == null) {
      setState(() {
        message = 'Please enter a valid student ID.';
      });
      return;
    }

    final count = await database!.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (!mounted) return;

    setState(() {
      message = count > 0
          ? 'Student with ID $id deleted successfully!'
          : 'No student found with ID $id.';
    });
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Student ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: database == null ? null : deleteStudent,
              child: const Text('
Delete Student'),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
