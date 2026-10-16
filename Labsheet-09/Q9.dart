import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post {
  final int id;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModelApiScreen(),
    );
  }
}

class ModelApiScreen extends StatefulWidget {
  const ModelApiScreen({super.key});

  @override
  State<ModelApiScreen> createState() => _ModelApiScreenState();
}

class _ModelApiScreenState extends State<ModelApiScreen> {
  List<Post> posts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final List<dynamic> jsonList = jsonDecode(response.body);

      final List<Post> loadedPosts = jsonList
          .map(
            (item) => Post.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        posts = loadedPosts;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load posts: $e';
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
        title: const Text('Posts Using Model Class'),
        actions: [
          IconButton(
            onPressed: fetchPosts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Text(errorMessage!),
                )
              : posts.isEmpty
                  ? const Center(
                      child: Text('No posts available'),
                    )
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Post ID: ${post.id}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  post.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(post.body),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
