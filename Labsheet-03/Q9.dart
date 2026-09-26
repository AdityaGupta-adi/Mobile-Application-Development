import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const EvenOddScreen(),
    );
  }
}

class EvenOddScreen extends StatefulWidget {
  const EvenOddScreen({super.key});

  @override
  State<EvenOddScreen> createState() => _EvenOddScreenState();
}

class _EvenOddScreenState extends State<EvenOddScreen> {
  final TextEditingController numberController = TextEditingController();

  String result = '';

  void checkNumber() {
    int? number = int.tryParse(numberController.text);

    if (number == null) {
      setState(() {
        result = 'Please enter a valid number.';
      });
      return;
    }

    setState(() {
      result = number % 2 == 0
          ? '$number is Even'
          : '$number is Odd';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Even or Odd'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkNumber,
              child: const Text('Check'),
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
