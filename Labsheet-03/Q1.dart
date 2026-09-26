import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NameScreen(),
    );
  }
}

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController nameController = TextEditingController();
  String name = '';

  void displayName() {
    setState(() {
      name = nameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Enter Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: displayName,
              child: const Text('Display Name'),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
