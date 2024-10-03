import 'package:flutter/material.dart';

class BoxingProgramPage extends StatelessWidget {
  const BoxingProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boxing Program'),
        backgroundColor: const Color(0xFF29282C), // Dark background
      ),
      body: const Center(
        child: Text(
          'Welcome to the Boxing Program!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF29282C), // Dark background
    );
  }
}
