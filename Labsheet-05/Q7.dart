import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.home,
      Icons.person,
      Icons.settings,
      Icons.camera_alt,
      Icons.phone,
      Icons.email,
      Icons.favorite,
      Icons.star,
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Icon Grid'),
        ),
        body: GridView.count(
          crossAxisCount: 4,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: icons.map((icon) {
            return Card(
              child: Icon(
                icon,
                size: 40,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
