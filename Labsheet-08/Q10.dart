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
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  Database? database;

  final taskController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q10_tasks.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            completed INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );

    await loadTasks();
  }

  Future<void> loadTasks() async {
    if (database == null) return;

    final result = await database!.query(
      'tasks',
      orderBy: 'id DESC',
    );

    if (!mounted) return;

    setState(() {
      tasks = result;
    });
  }

  Future<void> addTask() async {
    if (database == null) return;

    final title = taskController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task'),
        ),
      );
      return;
    }

    await database!.insert('tasks', {
      'title': title,
      'completed': 0,
    });

    taskController.clear();
    await loadTasks();
  }

  Future<void> updateTaskStatus(
    int id,
    bool completed,
  ) async {
    if (database == null) return;

    await database!.update(
      'tasks',
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadTasks();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite To-Do App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: addTask,
                  icon: const Icon(Icons.add_circle),
                  iconSize: 38,
                  tooltip: 'Add Task',
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text('No tasks added yet'),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final isCompleted = task['completed'] == 1;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: CheckboxListTile(
                          value: isCompleted,
                          onChanged: (value) {
                            updateTaskStatus(
                              task['id'] as int,
                              value ?? false,
                            );
                          },
                          title: Text(
                            task['title'],
                            style: TextStyle(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: isCompleted ? Colors.grey : null,
                            ),
                          ),
                          secondary: Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                          ),
controlAffinity:
                              ListTileControlAffinity.leading,
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
