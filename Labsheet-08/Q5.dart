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
      home: ContactBookScreen(),
    );
  }
}

class ContactBookScreen extends StatefulWidget {
  const ContactBookScreen({super.key});

  @override
  State<ContactBookScreen> createState() => _ContactBookScreenState();
}

class _ContactBookScreenState extends State<ContactBookScreen> {
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
    final path = join(dbPath, 'q5_contacts.db');

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

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact saved successfully')),
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
        title: const Text('SQLite Contact Book'),
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
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(contact['name']),
                        subtitle: Text(contact['phone']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
