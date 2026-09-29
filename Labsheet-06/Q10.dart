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
      home: const ClearDataScreen(),
    );
  }
}

class ClearDataScreen extends StatefulWidget {
  const ClearDataScreen({super.key});

  @override
  State<ClearDataScreen> createState() => _ClearDataScreenState();
}

class _ClearDataScreenState extends State<ClearDataScreen> {
  String savedData = 'No data saved';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      savedData = prefs.getString('data') ?? 'No data saved';
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'data',
      'This is saved SharedPreferences data.',
    );

    setState(() {
      savedData = 'This is saved SharedPreferences data.';
    });
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    setState(() {
      savedData = 'No data saved';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clear SharedPreferences'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                savedData,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: saveData,
                child: const Text('Save Data'),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: clearData,
                child: const Text('Clear Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
