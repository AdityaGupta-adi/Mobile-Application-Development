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
      home: PasswordResetScreen(),
    );
  }
}

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState
    extends State<PasswordResetScreen> {
  final emailController = TextEditingController();

  bool isLoading = false;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage('Please enter your registered email');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      showMessage(
        'If the account is eligible, a password reset email will be sent.',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      switch (e.code) {
        case 'invalid-email':
          showMessage('Please enter a valid email address.');
          break;
        case 'too-many-requests':
          showMessage('Too many requests. Try again later.');
          break;
        default:
          showMessage(
            e.message ?? 'Unable to request password reset.',
          );
      }
    } catch (e) {
      if (!mounted) return;
      showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_reset,
              size: 75,
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter your registered email address. '
              'Firebase can send you a password reset link.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Registered Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : resetPassword,
                icon: const Icon(Icons.send),
                label: Text(
                  isLoading ? 'Sending...' : 'Send Reset Link',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
