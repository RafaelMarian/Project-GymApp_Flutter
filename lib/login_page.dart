import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'questionnaire_page.dart'; // Import the questionnaire page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Successfully logged in, navigate to QuestionnairePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QuestionnairePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF29282C), // Dark grey background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Gym Buddies',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF), // White text
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Color(0xFFFFFFFF)), // White text
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFFFFF)), // White border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFFFFF)), // White border
                ),
                filled: true,
                fillColor: Color(0xFF29282C), // Dark grey background for text fields
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Color(0xFFFFFFFF)), // White text
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFFFFF)), // White border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFFFFF)), // White border
                ),
                filled: true,
                fillColor: Color(0xFF29282C),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E), // yellow button
              ),
              onPressed: _login,
              child: const Text(
                'Login',
                style: TextStyle(color: Color(0xFFFFFFFF)), // White text
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () {
                // Navigate to forgot password
              },
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: Color(0xFFFFFFFF)), // White text
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the Sign-Up page
              },
              child: const Text(
                'Don’t have an account? Sign up',
                style: TextStyle(color: Color(0xFFFFFFFF)), // White text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
