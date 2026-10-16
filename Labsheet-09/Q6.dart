import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilderScreen(),
    );
  }
}

class FutureBuilderScreen extends StatefulWidget {
  const FutureBuilderScreen({super.key});

  @override
  State<FutureBuilderScreen> createState() =>
      _FutureBuilderScreenState();
}

class _FutureBuilderScreenState extends State<FutureBuilderScreen> {
  late Future<Map<String, dynamic>> postFuture;

  @override
  void initState() {
    super.initState();
    postFuture = fetchPost();
  }

  Future<Map<String, dynamic>> fetchPost() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load post: ${response.statusCode}');
    }
  }

  void retry() {
    setState(() {
      postFuture = fetchPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FutureBuilder Example'),
        actions: [
          IconButton(
            onPressed: retry,
            icon: const Icon(Icons.refresh),
            tooltip: 'Retry',
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: retry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'),
            );
          }

          final post = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post ID: ${post['id']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      post['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      post['body'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
