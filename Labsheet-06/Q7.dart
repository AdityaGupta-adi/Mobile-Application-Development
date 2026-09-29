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
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController =
      TextEditingController();

  bool rememberMe = false;
  String savedUsername = '';

  @override
  void initState() {
    super.initState();
    loadLoginData();
  }

  Future<void> loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;

      if (rememberMe) {
        savedUsername = prefs.getString('username') ?? '';
        usernameController.text = savedUsername;
      }
    });
  }

  Future<void> saveLoginData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('rememberMe', rememberMe);

    if (rememberMe) {
      await prefs.setString(
        'username',
        usernameController.text,
      );
    } else {
      await prefs.remove('username');
    }

    setState(() {
      savedUsername = usernameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remember Me Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            CheckboxListTile(
              title: const Text('Remember Me'),
              value: rememberMe,
              onChanged: (value) {
                setState(() {
                  rememberMe = value ?? false;
                });
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: saveLoginData,
              child: const Text('Login'),
            ),

            const SizedBox(height: 20),

            Text(
              savedUsername.isEmpty
                  ? 'No saved username'
                  : 'Saved Username: $savedUsername',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
