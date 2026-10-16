import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddStudentScreen(),
    );
  }
}

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final courseController = TextEditingController();

  bool isLoading = false;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> addStudent() async {
    final name = nameController.text.trim();
    final roll = rollController.text.trim();
    final course = courseController.text.trim();

    if (name.isEmpty || roll.isEmpty || course.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('students')
          .add({
        'name': name,
        'rollNumber': roll,
        'course': course,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      nameController.clear();
      rollController.clear();
      courseController.clear();

      showMessage('Student added successfully');
    } on FirebaseException catch (e) {
      if (!mounted) return;
      showMessage(e.message ?? 'Unable to save student');
    } catch (e) {
      if (!mounted) return;
      showMessage('Something went wrong');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student to Firestore'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.school,
              size: 75,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: rollController,
              decoration: const InputDecoration(
                labelText: 'Roll Number',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                prefixIcon: Icon(Icons.book),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : addStudent,
                icon: const Icon(Icons.save),
                label: Text(
                  isLoading ? 'Saving...' : 'Save Student',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
