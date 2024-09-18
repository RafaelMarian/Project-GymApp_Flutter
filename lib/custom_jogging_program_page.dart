import 'package:flutter/material.dart';

class CustomJoggingProgramPage extends StatelessWidget {
  const CustomJoggingProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Jogging Program'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41),
      body: const Center(
        child: Text(
          'Custom Jogging Program Page',
          style: TextStyle(color: Color(0xFFF7BB0E), fontSize: 24),
        ),
      ),
    );
  }
}
