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
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Database? database;

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q1_notes.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE notes ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'title TEXT NOT NULL, '
          'content TEXT NOT NULL)',
        );
      },
    );

    await loadNotes();
  }

  Future<void> loadNotes() async {
    if (database == null) return;

    final result = await database!.query(
      'notes',
      orderBy: 'id DESC',
    );

    if (!mounted) return;

    setState(() {
      notes = result;
    });
  }

  Future<void> addNote() async {
    if (database == null) return;

    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter title and content'),
        ),
      );
      return;
    }

    await database!.insert('notes', {
      'title': title,
      'content': content,
    });

    titleController.clear();
    contentController.clear();

    await loadNotes();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Notes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Note Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Note Content',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addNote,
                  child: const Text('Add Note'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: notes.isEmpty
                ? const Center(child: Text('No notes available'))
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.note),
                          title: Text(note['title']),
                          subtitle: Text(note['content']),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
