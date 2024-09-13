import 'package:flutter/material.dart';

class CustomCyclingProgramPage extends StatelessWidget {
  const CustomCyclingProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Cycling Program'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: const Center(
        child: Text(
          'Create your custom cycling program here!',
          style: TextStyle(fontSize: 18, color: Colors.yellow),
        ),
      ),
    );
  }
}
