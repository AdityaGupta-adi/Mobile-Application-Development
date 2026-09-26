import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ResultScreen(),
    );
  }
}

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subject1Controller = TextEditingController();
  final TextEditingController subject2Controller = TextEditingController();
  final TextEditingController subject3Controller = TextEditingController();

  String result = '';

  void calculateTotal() {
    double marks1 = double.tryParse(subject1Controller.text) ?? 0;
    double marks2 = double.tryParse(subject2Controller.text) ?? 0;
    double marks3 = double.tryParse(subject3Controller.text) ?? 0;

    double total = marks1 + marks2 + marks3;

    setState(() {
      result = 'Student: ${nameController.text}\nTotal Marks: $total';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: subject1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Subject 1 Marks',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: subject2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Subject 2 Marks',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: subject3Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Subject 3 Marks',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateTotal,
              child: const Text('Calculate Total'),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
