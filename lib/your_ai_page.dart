import 'package:flutter/material.dart';

class YourAIPage extends StatelessWidget {
  const YourAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your AI Assistant'),
        backgroundColor: const Color(0xFF29282C), // Dark background
      ),
      body: const Center(
        child: Text(
          'Welcome to Your AI Assistant!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF29282C), // Dark background
    );
  }
}
