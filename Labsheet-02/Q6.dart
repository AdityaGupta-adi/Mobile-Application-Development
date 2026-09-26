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
          title: const Text('Text, Image and Icon'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Flutter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Image.network(
                'https://picsum.photos/200',
                width: 200,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.flutter_dash,
                size: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
