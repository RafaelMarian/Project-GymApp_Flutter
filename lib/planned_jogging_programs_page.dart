import 'package:flutter/material.dart';

class PlannedJoggingProgramsPage extends StatelessWidget {
  const PlannedJoggingProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned Jogging Programs'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: const Center(
        child: Text(
          'Planned Jogging Programs Page',
          style: TextStyle(color: Colors.yellow, fontSize: 24),
        ),
      ),
    );
  }
}
