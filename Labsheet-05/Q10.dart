import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stateless vs Stateful'),
        ),
        body: const DemoScreen(),
      ),
    );
  }
}

// StatelessWidget: UI does not change by itself.
class StaticText extends StatelessWidget {
  const StaticText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'This is a StatelessWidget',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// StatefulWidget: UI can change when state changes.
class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const StaticText(),

          const SizedBox(height: 30),

          const Text(
            'This is a StatefulWidget',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            'Counter: $count',
            style: const TextStyle(fontSize: 24),
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: increment,
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}
