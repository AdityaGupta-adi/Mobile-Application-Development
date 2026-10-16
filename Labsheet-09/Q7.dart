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
      home: PostsScreen(),
    );
  }
}

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<dynamic> posts = [];
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        if (!mounted) return;

        setState(() {
          posts = data;
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
        errorMessage = 'Unable to fetch posts. Check your internet.';
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
        title: const Text('Posts List'),
        actions: [
          IconButton(
            onPressed: fetchPosts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : posts.isEmpty
                  ? const Center(child: Text('No posts available'))
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post =
                            posts[index] as Map<String, dynamic>;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${post['id']}'),
                            ),
                            title: Text(
                              post['title'] ?? 'No title',
                            ),
                            subtitle: Text(
                              'Post ID: ${post['id']}',
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
