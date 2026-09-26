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
          title: const Text('Student Information'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Name: Aditya Gupta'),
              Text('Course: BCA'),
              Text('Semester: 5th Semester'),
              Text('College: COER University'),
            ],
          ),
        ),
      ),
    );
  }
}
