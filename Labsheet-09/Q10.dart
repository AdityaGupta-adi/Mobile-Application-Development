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
      home: ErrorHandlingScreen(),
    );
  }
}

class ErrorHandlingScreen extends StatefulWidget {
  const ErrorHandlingScreen({super.key});

  @override
  State<ErrorHandlingScreen> createState() =>
      _ErrorHandlingScreenState();
}

class _ErrorHandlingScreenState
    extends State<ErrorHandlingScreen> {
  Map<String, dynamic>? post;
  bool isLoading = false;
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
      final response = await http
          .get(
            Uri.parse(
              'https://jsonplaceholder.typicode.com/posts/1',
            ),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          'Server returned status code ${response.statusCode}',
        );
      }

      final data =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (!mounted) return;

      setState(() {
        post = data;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        post = null;
        errorMessage =
            'Failed to fetch data. Check your internet connection and retry.';
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
        title: const Text('API Error Handling'),
      ),
      body: Center(
        child: isLoading
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading data...'),
                ],
              )
            : errorMessage != null
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 55,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: fetchPost,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : post == null
                    ? const Text('No data available')
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Post ID: ${post!['id']}',
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
      ),
    );
  }
}
