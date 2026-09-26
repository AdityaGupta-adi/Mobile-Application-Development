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
          title: const Text('ListView Example'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            ListTile(
              title: Text('Apple'),
            ),
            ListTile(
              title: Text('Banana'),
            ),
            ListTile(
              title: Text('Mango'),
            ),
            ListTile(
              title: Text('Orange'),
            ),
            ListTile(
              title: Text('Grapes'),
            ),
          ],
        ),
      ),
    );
  }
}
