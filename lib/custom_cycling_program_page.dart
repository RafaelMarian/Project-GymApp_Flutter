import 'package:flutter/material.dart';

class CustomCyclingProgramPage extends StatelessWidget {
  const CustomCyclingProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Cycling Program'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41),
      body: const Center(
        child: Text(
          'Create your custom cycling program here!',
          style: TextStyle(fontSize: 18, color: Color(0xFFF7BB0E)),
        ),
      ),
    );
  }
}
