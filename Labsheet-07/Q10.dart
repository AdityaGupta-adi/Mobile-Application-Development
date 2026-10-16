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
      home: ClearAllScreen(),
    );
  }
}

class ClearAllScreen extends StatefulWidget {
  const ClearAllScreen({super.key});

  @override
  State<ClearAllScreen> createState() => _ClearAllScreenState();
}

class _ClearAllScreenState extends State<ClearAllScreen> {
  Database? database;
  List<Map<String, dynamic>> students = [];
  String message = 'Opening database...';

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q10_students.db');

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

    await loadStudents();
  }

  Future<void> loadStudents() async {
    if (database == null) return;

    final result = await database!.query('students');

    if (!mounted) return;

    setState(() {
      students = result;
      message = students.isEmpty
          ? 'No student records found.'
          : '${students.length} student record(s) found.';
    });
  }

  Future<void> clearAll() async {
    if (database == null) return;

    final count = await database!.delete('students');

    if (!mounted) return;

    setState(() {
      students.clear();
      message = '$count student record(s) deleted.';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All student records deleted.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clear All Students'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: database == null ? null : clearAll,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Clear All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? const Center(
                    child: Text('No students available'),
                  )
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${student['id']}'),
                        ),
                        title: Text(student['name'] ?? ''),
                        subtitle: Text(
                          'Roll Number: ${student['rollNumber']}\n'
                          'Course: ${student['course']}',
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
