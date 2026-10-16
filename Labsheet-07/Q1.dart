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
      home: DatabaseScreen(),
    );
  }
}

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  String message = 'Creating database...';

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  Future<void> createDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'student_database.db');

      await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE students ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name TEXT, '
            'rollNumber TEXT, '
            'course TEXT)',
          );
        },
      );

      setState(() {
        message = 'SQLite Database Created Successfully!';
      });
    } catch (e) {
      setState(() {
        message = 'Database creation failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Database'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
