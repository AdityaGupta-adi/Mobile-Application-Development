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
      home: InsertStudentScreen(),
    );
  }
}

class InsertStudentScreen extends StatefulWidget {
  const InsertStudentScreen({super.key});

  @override
  State<InsertStudentScreen> createState() =>
      _InsertStudentScreenState();
}

class _InsertStudentScreenState extends State<InsertStudentScreen> {
  Database? database;
  String message = 'Opening database...';

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q3_students.db');

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

    setState(() {
      message = 'Database ready';
    });
  }

  Future<void> insertStudent() async {
    if (database == null) return;

    await database!.insert('students', {
      'name': 'Aditya',
      'rollNumber': '101',
      'course': 'BCA',
    });

    setState(() {
      message = 'Student inserted successfully!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert Student Record'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: database == null ? null : insertStudent,
                child: const Text('Insert Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
