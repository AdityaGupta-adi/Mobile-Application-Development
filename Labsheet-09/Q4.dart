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
      home: SinglePostScreen(),
    );
  }
}

class SinglePostScreen extends StatefulWidget {
  const SinglePostScreen({super.key});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  Map<String, dynamic>? post;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  Future<void> fetchPost() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (!mounted) return;

        setState(() {
          post = data;
        });
      } else {
        if (!mounted) return;

        setState(() {
          errorMessage = 'HTTP Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to fetch post. Check your internet.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Post'),
        actions: [
          IconButton(
            onPressed: fetchPost,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
                ? Text(errorMessage!)
                : post == null
                    ? const Text('No post available')
                    : Card(
                        margin: const EdgeInsets.all(16),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Post ID: ${post!['id']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                post!['title'] ?? 'No title',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                post!['body'] ?? 'No body',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
