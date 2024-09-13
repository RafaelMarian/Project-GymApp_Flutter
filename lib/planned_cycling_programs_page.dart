import 'package:flutter/material.dart';

class PlannedCyclingProgramsPage extends StatelessWidget {
  const PlannedCyclingProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned Cycling Programs'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: const Center(
        child: Text(
          'Choose from various planned cycling programs!',
          style: TextStyle(fontSize: 18, color: Colors.yellow),
        ),
      ),
    );
  }
}
