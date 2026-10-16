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
      home: ApiResponseScreen(),
    );
  }
}

class ApiResponseScreen extends StatefulWidget {
  const ApiResponseScreen({super.key});

  @override
  State<ApiResponseScreen> createState() => _ApiResponseScreenState();
}

class _ApiResponseScreenState extends State<ApiResponseScreen> {
  String responseBody = 'Press the button to fetch data.';
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      responseBody = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      );

      if (response.statusCode == 200) {
        setState(() {
          responseBody = response.body;
        });
      } else {
        setState(() {
          responseBody = 'Error: HTTP ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        responseBody = 'Failed to fetch data: $e';
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
        title: const Text('REST API Response'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : fetchData,
              child: const Text('Fetch API Data'),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(responseBody),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
