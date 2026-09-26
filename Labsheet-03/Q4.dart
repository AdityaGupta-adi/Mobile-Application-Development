import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TextChangeScreen(),
    );
  }
}

class TextChangeScreen extends StatefulWidget {
  const TextChangeScreen({super.key});

  @override
  State<TextChangeScreen> createState() => _TextChangeScreenState();
}

class _TextChangeScreenState extends State<TextChangeScreen> {
  String message = 'Press the button';

  void changeText() {
    setState(() {
      message = 'Button Pressed!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: changeText,
              child: const Text('Change Text'),
            ),
          ],
        ),
      ),
    );
  }
}
