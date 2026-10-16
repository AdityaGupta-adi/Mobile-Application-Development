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
      home: SearchNotesScreen(),
    );
  }
}

class SearchNotesScreen extends StatefulWidget {
  const SearchNotesScreen({super.key});

  @override
  State<SearchNotesScreen> createState() => _SearchNotesScreenState();
}

class _SearchNotesScreenState extends State<SearchNotesScreen> {
  Database? database;

  final searchController = TextEditingController();
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
    final path = join(dbPath, 'q4_notes.db');

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

    await searchNotes('');
  }

  Future<void> searchNotes(String query) async {
    if (database == null) return;

    final result = await database!.query(
      'notes',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
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

    await searchNotes(searchController.text);
  }

  @override
  void dispose() {
    searchController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Notes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: searchNotes,
                  decoration: InputDecoration(
                    labelText: 'Search by Title',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        searchNotes('');
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'New Note Title',
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
          Expanded(
            child: notes.isEmpty
                ? const Center(
                    child: Text('No matching notes found'),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return ListTile(
                        leading: const Icon(Icons.note),
                        title: Text(note['title']),
                        subtitle: Text(note['content']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
