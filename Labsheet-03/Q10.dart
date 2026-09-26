import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NumberCheckScreen(),
    );
  }
}

class NumberCheckScreen extends StatefulWidget {
  const NumberCheckScreen({super.key});

  @override
  State<NumberCheckScreen> createState() => _NumberCheckScreenState();
}

class _NumberCheckScreenState extends State<NumberCheckScreen> {
  final TextEditingController numberController = TextEditingController();

  String result = '';

  void checkNumber() {
    double? number = double.tryParse(numberController.text);

    if (number == null) {
      setState(() {
        result = 'Please enter a valid number.';
      });
      return;
    }

    if (number > 0) {
      result = '$number is Positive';
    } else if (number < 0) {
      result = '$number is Negative';
    } else {
      result = 'The number is Zero';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Check'),
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
              child: const Text('Check Number'),
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
