import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PercentageScreen(),
    );
  }
}

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});

  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  final TextEditingController subject1Controller = TextEditingController();
  final TextEditingController subject2Controller = TextEditingController();
  final TextEditingController subject3Controller = TextEditingController();

  String result = '';

  void calculatePercentage() {
    double marks1 = double.tryParse(subject1Controller.text) ?? 0;
    double marks2 = double.tryParse(subject2Controller.text) ?? 0;
    double marks3 = double.tryParse(subject3Controller.text) ?? 0;

    double total = marks1 + marks2 + marks3;
    double percentage = (total / 300) * 100;

    setState(() {
      result = 'Percentage: ${percentage.toStringAsFixed(2)}%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Percentage Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
              onPressed: calculatePercentage,
              child: const Text('Calculate Percentage'),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
