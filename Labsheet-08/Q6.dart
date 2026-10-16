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
      home: DeleteContactScreen(),
    );
  }
}

class DeleteContactScreen extends StatefulWidget {
  const DeleteContactScreen({super.key});

  @override
  State<DeleteContactScreen> createState() =>
      _DeleteContactScreenState();
}

class _DeleteContactScreenState extends State<DeleteContactScreen> {
  Database? database;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q6_contacts.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE contacts ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT NOT NULL, '
          'phone TEXT NOT NULL)',
        );
      },
    );

    await loadContacts();
  }

  Future<void> loadContacts() async {
    if (database == null) return;

    final result = await database!.query(
      'contacts',
      orderBy: 'name ASC',
    );

    if (!mounted) return;

    setState(() {
      contacts = result;
    });
  }

  Future<void> addContact() async {
    if (database == null) return;

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter name and phone number'),
        ),
      );
      return;
    }

    await database!.insert('contacts', {
      'name': name,
      'phone': phone,
    });

    nameController.clear();
    phoneController.clear();

    await loadContacts();
  }

  Future<void> confirmDelete(
    Map<String, dynamic> contact,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: Text(
            'Are you sure you want to delete '
            '${contact['name']}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || database == null) return;

    await database!.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [contact['id']],
    );

    await loadContacts();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${contact['name']} deleted successfully'),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Book - Delete'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addContact,
                  child: const Text('Add Contact'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: contacts.isEmpty
                ? const Center(child: Text('No contacts available'))
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];

                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(contact['name']),
                        subtitle: Text(contact['phone']),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => confirmDelete(contact),
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
