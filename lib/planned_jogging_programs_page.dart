import 'package:flutter/material.dart';

class PlannedJoggingProgramsPage extends StatelessWidget {
  const PlannedJoggingProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned Jogging Programs'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41),
      body: const Center(
        child: Text(
          'Planned Jogging Programs Page',
          style: TextStyle(color: Color(0xFFF7BB0E), fontSize: 24),
        ),
      ),
    );
  }
}
