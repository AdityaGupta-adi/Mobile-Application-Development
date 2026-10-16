import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserHomeScreen(),
    );
  }
}

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  bool isLoading = false;

  Future<void> logoutUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout successful'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Logout failed'),
        ),
      );
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
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: user == null
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No user is currently logged in.\n'
                  'Please log in first.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      child: Icon(
                        Icons.person,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Logged-in Email:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      user.email ?? 'Email not available',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : logoutUser,
                        icon: const Icon(Icons.logout),
                        label: Text(
                          isLoading ? 'Logging out...' : 'Logout',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
