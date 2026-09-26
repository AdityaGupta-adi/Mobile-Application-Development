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
          title: const Text('Text Styles'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bold Text',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Italic Text',
                style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Large Text',
                style: TextStyle(fontSize: 32),
              ),
              Text(
                'Centered Text',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
