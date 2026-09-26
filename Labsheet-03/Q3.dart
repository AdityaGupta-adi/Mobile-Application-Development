import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();

  String result = 'Result: ';

  double get first => double.tryParse(firstController.text) ?? 0;
  double get second => double.tryParse(secondController.text) ?? 0;

  void calculate(String operation) {
    double value;

    switch (operation) {
      case 'Add':
        value = first + second;
        break;
      case 'Subtract':
        value = first - second;
        break;
      case 'Multiply':
        value = first * second;
        break;
      case 'Divide':
        if (second == 0) {
          setState(() {
            result = 'Cannot divide by zero';
          });
          return;
        }
        value = first / second;
        break;
      default:
        value = 0;
    }

    setState(() {
      result = 'Result: $value';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'First Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: secondController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Second Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => calculate('Add'),
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () => calculate('Subtract'),
                  child: const Text('Subtract'),
                ),
                ElevatedButton(
                  onPressed: () => calculate('Multiply'),
                  child: const Text('Multiply'),
                ),
                ElevatedButton(
                  onPressed: () => calculate('Divide'),
                  child: const Text('Divide'),
                ),
              ],
            ),
            const SizedBox(height: 25),
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
