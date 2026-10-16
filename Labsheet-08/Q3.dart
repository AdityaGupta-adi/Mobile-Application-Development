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
      home: SwipeNotesScreen(),
    );
  }
}

class SwipeNotesScreen extends StatefulWidget {
  const SwipeNotesScreen({super.key});

  @override
  State<SwipeNotesScreen> createState() => _SwipeNotesScreenState();
}

class _SwipeNotesScreenState extends State<SwipeNotesScreen> {
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
    final path = join(dbPath, 'q3_notes.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE notes ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'title TEXT NOT NULL, content TEXT NOT NULL)',
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
          content: Text('Enter title and content'),
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

  Future<void> deleteNote(int id) async {
    await database!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadNotes();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted successfully'),
      ),
    );
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
        title: const Text('Swipe to Delete Notes'),
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
          const Text('Swipe a note to delete it'),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Dismissible(
                  key: ValueKey(note['id']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) {
                    deleteNote(note['id'] as int);
                  },
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
