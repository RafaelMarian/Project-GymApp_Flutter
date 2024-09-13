import 'package:flutter/material.dart';

class CustomJoggingProgramPage extends StatelessWidget {
  const CustomJoggingProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Jogging Program'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: const Center(
        child: Text(
          'Custom Jogging Program Page',
          style: TextStyle(color: Colors.yellow, fontSize: 24),
        ),
      ),
    );
  }
}
