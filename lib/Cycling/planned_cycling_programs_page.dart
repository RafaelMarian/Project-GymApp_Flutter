import 'package:flutter/material.dart';

class PlannedCyclingProgramsPage extends StatelessWidget {
  const PlannedCyclingProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned Cycling Programs'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: const Center(
        child: Text(
          'Choose from various planned cycling programs!',
          style: TextStyle(fontSize: 18, color: Color(0xFFF7BB0E)),
        ),
      ),
    );
  }
}
