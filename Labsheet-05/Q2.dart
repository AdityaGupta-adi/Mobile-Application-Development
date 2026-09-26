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
          title: const Text('ListTile Example'),
        ),
        body: ListView(
          children: const [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Aditya Gupta'),
              subtitle: Text('BCA Student'),
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('COER University'),
              subtitle: Text('Computer Applications'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('Student Email'),
            ),
          ],
        ),
      ),
    );
  }
}
