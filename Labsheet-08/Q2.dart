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
      home: EditableNotesScreen(),
    );
  }
}

class EditableNotesScreen extends StatefulWidget {
  const EditableNotesScreen({super.key});

  @override
  State<EditableNotesScreen> createState() =>
      _EditableNotesScreenState();
}

class _EditableNotesScreenState extends State<EditableNotesScreen> {
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
    final path = join(dbPath, 'q2_notes.db');

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

  Future<void> saveNote() async {
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

  Future<void> editNote(Map<String, dynamic> note) async {
    final titleEditController = TextEditingController(
      text: note['title'],
    );
    final contentEditController = TextEditingController(
      text: note['content'],
    );

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleEditController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: contentEditController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    if (shouldSave == true &&
        titleEditController.text.trim().isNotEmpty &&
        contentEditController.text.trim().isNotEmpty) {
      await database!.update(
        'notes',
        {
          'title': titleEditController.text.trim(),
          'content': contentEditController.text.trim(),
        },
        where: 'id = ?',
        whereArgs: [note['id']],
      );

      await loadNotes();
    }

    titleEditController.dispose();
    contentEditController.dispose();
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
        title: const Text('Edit SQLite Notes'),
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
                    labelText: 'New Note Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,decoration: const InputDecoration(
                    labelText: 'New Note Content',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: saveNote,
                  child: const Text('Add Note'),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Tap a note to edit it'),
          ),
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
                          leading: const Icon(Icons.edit_note),
                          title: Text(note['title']),
                          subtitle: Text(note['content']),
                          trailing: const Icon(Icons.edit),
                          onTap: () => editNote(note),
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
