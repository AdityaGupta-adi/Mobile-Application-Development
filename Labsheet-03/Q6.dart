import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FormScreen(),
    );
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController nameController = TextEditingController();

  String message = '';

  void submitForm() {
    setState(() {
      message = 'Form Submitted: ${nameController.text}';
    });
  }

  void resetForm() {
    nameController.clear();

    setState(() {
      message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Enter Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: submitForm,
                  child: const Text('Submit'),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: resetForm,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
