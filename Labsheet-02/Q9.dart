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
          title: const Text('Column Widget'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Name: Aditya Gupta',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 15),
              Text(
                'Course: BCA',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 15),
              Text(
                'College: COER University',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
