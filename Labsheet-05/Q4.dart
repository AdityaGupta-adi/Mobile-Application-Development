import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> names = [
      'Aditya',
      'Rahul',
      'Aman',
      'Priya',
      'Neha',
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Student Names'),
        ),
        body: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(names[index]),
            );
          },
        ),
      ),
    );
  }
}
