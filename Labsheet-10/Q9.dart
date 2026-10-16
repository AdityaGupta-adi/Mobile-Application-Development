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
      home: StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Student Records'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load student records'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return const Center(
              child: Text('No student records found'),
            );
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final student = documents[index].data();

              final name = student['name']?.toString() ?? 'Unknown';
              final rollNumber =
                  student['rollNumber']?.toString() ?? 'N/A';
              final course = student['course']?.toString() ?? 'N/A';

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                    ),
                  ),
                  title: Text(name),
                  subtitle: Text(
                    'Roll Number: $rollNumber\nCourse: $course',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
