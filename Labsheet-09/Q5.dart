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
      home: LoadingApiScreen(),
    );
  }
}

class LoadingApiScreen extends StatefulWidget {
  const LoadingApiScreen({super.key});

  @override
  State<LoadingApiScreen> createState() => _LoadingApiScreenState();
}

class _LoadingApiScreenState extends State<LoadingApiScreen> {
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
        final data =
            jsonDecode(response.body) as Map<String, dynamic>;

        if (!mounted) return;

        setState(() {
          post = data;
        });
      } else {
        if (!mounted) return;

        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to connect. Check your internet.';
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
        title: const Text('API Loading Indicator'),
        actions: [
          IconButton(
            onPressed: fetchPost,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Fetching data from API...'),
                ],
              )
            : errorMessage != null
                ? Text(errorMessage!)
                : post == null
                    ? const Text('No data available')
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              post!['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(post!['body'] ?? ''),
                          ],
                        ),
                      ),
      ),
    );
  }
}
