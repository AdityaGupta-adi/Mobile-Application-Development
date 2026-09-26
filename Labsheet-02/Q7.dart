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
          title: const Text('Container Widget'),
        ),
        body: Center(
          child: Container(
            width: 300,
            height: 200,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 2),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Customized Container',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
