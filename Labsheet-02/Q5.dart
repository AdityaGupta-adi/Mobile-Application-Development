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
          title: const Text('Icon Widget'),
        ),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home,
                size: 50,
              ),
              SizedBox(width: 25),
              Icon(
                Icons.favorite,
                size: 50,
              ),
              SizedBox(width: 25),
              Icon(
                Icons.settings,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
