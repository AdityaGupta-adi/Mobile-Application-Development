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
      home: RawQueryScreen(),
    );
  }
}

class RawQueryScreen extends StatefulWidget {
  const RawQueryScreen({super.key});

  @override
  State<RawQueryScreen> createState() => _RawQueryScreenState();
}

class _RawQueryScreenState extends State<RawQueryScreen> {
  Database? database;
  List<Map<String, dynamic>> students = [];
  String message = 'Loading records...';

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q7_students.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE students ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT, rollNumber TEXT, course TEXT)',
        );

        await db.rawInsert(
          'INSERT INTO students (name, rollNumber, course) '
          'VALUES (?, ?, ?)',
          ['Aditya', '101', 'BCA'],
        );

        await db.rawInsert(
          'INSERT INTO students (name, rollNumber, course) '
          'VALUES (?, ?, ?)',
          ['Rahul', '102', 'BCA'],
        );

        await db.rawInsert(
          'INSERT INTO students (name, rollNumber, course) '
          'VALUES (?, ?, ?)',
          ['Priya', '103', 'MCA'],
        );
      },
    );

    await loadStudents();
  }

  Future<void> loadStudents() async {
    if (database == null) return;

    final result = await database!.rawQuery(
      'SELECT * FROM students',
    );

    if (!mounted) return;

    setState(() {
      students = result;
      message = students.isEmpty ? 'No records found' : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Using rawQuery'),
        actions: [
          IconButton(
            onPressed: loadStudents,
            icon: const Icon(Icons.refresh),
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
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${student['id']}'),
                    ),
                    title: Text(student['name'] ?? ''),
                    subtitle: Text(
                      'Roll Number: ${student['rollNumber']}\n'
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
