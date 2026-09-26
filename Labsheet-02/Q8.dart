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
          title: const Text('Row Widget'),
        ),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Home',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 25),
              Text(
                'About',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 25),
              Text(
                'Contact',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
