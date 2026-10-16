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
      home: SearchContactsScreen(),
    );
  }
}

class SearchContactsScreen extends StatefulWidget {
  const SearchContactsScreen({super.key});

  @override
  State<SearchContactsScreen> createState() =>
      _SearchContactsScreenState();
}

class _SearchContactsScreenState extends State<SearchContactsScreen> {
  Database? database;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final searchController = TextEditingController();

  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'q7_contacts.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE contacts ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT NOT NULL, phone TEXT NOT NULL)',
        );
      },
    );

    await searchContacts('');
  }

  Future<void> searchContacts(String query) async {
    if (database == null) return;

    final result = await database!.rawQuery(
      'SELECT * FROM contacts WHERE name LIKE ? ORDER BY name ASC',
      ['%$query%'],
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
          content: Text('Enter name and phone number'),
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

    await searchContacts(searchController.text);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: searchContacts,
                  decoration: InputDecoration(
                    labelText: 'Search by Contact Name',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        searchContacts('');
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
                ? const Center(child: Text('No matching contacts'))
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];

                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(contact['name']),
                        subtitle: Text(contact['phone']),
                      );
                    },
                  ),
          )],
      ),
    );
  }
}
