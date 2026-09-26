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
          title: const Text('Button Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print('Submit button pressed');
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  print('Reset button pressed');
                },
                child: const Text('Reset'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  print('Cancel button pressed');
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
