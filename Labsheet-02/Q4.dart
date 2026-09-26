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
          title: const Text('Image Widget'),
        ),
        body: Center(
          child: Image.network(
            'https://picsum.photos/300/200',
            width: 300,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
