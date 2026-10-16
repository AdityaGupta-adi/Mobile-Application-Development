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
      home: UpdateStudentScreen(),
    );
  }
}

class UpdateStudentScreen extends StatefulWidget {
  const UpdateStudentScreen({super.key});

  @override
  State<UpdateStudentScreen> createState() =>
      _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  final documentIdController = TextEditingController();
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final courseController = TextEditingController();

  bool isLoading = false;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> loadStudent() async {
    final documentId = documentIdController.text.trim();

    if (documentId.isEmpty) {
      showMessage('Enter the student document ID');
      return;
    }

    setState(() => isLoading = true);

    try {
      final document = await FirebaseFirestore.instance
          .collection('students')
          .doc(documentId)
          .get();

      if (!mounted) return;

      if (!document.exists) {
        showMessage('Student record not found');
        return;
      }

      final data = document.data()!;

      setState(() {
        nameController.text = data['name']?.toString() ?? '';
        rollController.text =
            data['rollNumber']?.toString() ?? '';
        courseController.text = data['course']?.toString() ?? '';
      });

      showMessage('Student record loaded');
    } on FirebaseException catch (e) {
      if (!mounted) return;
      showMessage(e.message ?? 'Unable to load student');
    } catch (e) {
      if (!mounted) return;
      showMessage('Something went wrong');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> updateStudent() async {
    final documentId = documentIdController.text.trim();
    final name = nameController.text.trim();
    final rollNumber = rollController.text.trim();
    final course = courseController.text.trim();

    if (documentId.isEmpty ||
        name.isEmpty ||
        rollNumber.isEmpty ||
        course.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    setState(() => isLoading = true);

    try {
      final reference = FirebaseFirestore.instance
          .collection('students')
          .doc(documentId);

      final document = await reference.get();

      if (!document.exists) {
        if (!mounted) return;
        showMessage('Student record not found');
        return;
      }

      await reference.update({
        'name': name,
        'rollNumber': rollNumber,
        'course': course,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      showMessage('Student updated successfully');
    } on FirebaseException catch (e) {
      if (!mounted) return;
      showMessage(e.message ?? 'Unable to update student');
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
    documentIdController.dispose();
    nameController.dispose();
    rollController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student Record'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.edit_note, size: 70),
            const SizedBox(height: 20),
            TextField(
              controller: documentIdController,
              decoration: const InputDecoration(
                labelText: 'Firestore Document ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fingerprint),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isLoading ? null : loadStudent,
                child: const Text('Load Student Record'),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : updateStudent,
                icon: const Icon(Icons.save),
                label: Text(
                  isLoading ? 'Please wait...' : 'Update Student',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
