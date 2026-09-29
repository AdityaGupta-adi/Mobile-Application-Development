import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SubjectsScreen(),
    );
  }
}

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<String> subjects = [
    'Python',
    'Java',
    'DBMS',
    'Flutter',
    'Artificial Intelligence',
  ];

  List<String> savedSubjects = [];

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  Future<void> saveSubjects() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('subjects', subjects);

    setState(() {
      savedSubjects = List.from(subjects);
    });
  }

  Future<void> loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      savedSubjects = prefs.getStringList('subjects') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Subjects'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: saveSubjects,
            child: const Text('Save Subjects'),
          ),

          const SizedBox(height: 20),

          const Text(
            'Saved Subjects',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: savedSubjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(savedSubjects[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
