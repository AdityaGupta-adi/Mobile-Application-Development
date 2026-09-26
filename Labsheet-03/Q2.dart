import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SumScreen(),
    );
  }
}

class SumScreen extends StatefulWidget {
  const SumScreen({super.key});

  @override
  State<SumScreen> createState() => _SumScreenState();
}

class _SumScreenState extends State<SumScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();

  double result = 0;

  void calculateSum() {
    double first = double.tryParse(firstController.text) ?? 0;
    double second = double.tryParse(secondController.text) ?? 0;

    setState(() {
      result = first + second;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sum of Two Numbers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter First Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: secondController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Second Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateSum,
              child: const Text('Calculate Sum'),
            ),
            const SizedBox(height: 20),
            Text(
              'Sum: $result',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
