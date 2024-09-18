import 'package:flutter/material.dart';

class PlannedYogaProgramsPage extends StatefulWidget {
  const PlannedYogaProgramsPage({super.key});

  @override
  _PlannedYogaProgramsPageState createState() =>
      _PlannedYogaProgramsPageState();
}

class _PlannedYogaProgramsPageState extends State<PlannedYogaProgramsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned Yoga Programs'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProgramCard('Beginner Yoga'),
          _buildProgramCard('Intermediate Yoga'),
          _buildProgramCard('Advanced Yoga'),
          _buildProgramCard('Power Yoga'),
          _buildProgramCard('Relaxation Yoga'),
          // Add more programs as needed
        ],
      ),
    );
  }

  Widget _buildProgramCard(String programName) {
    return Card(
      color: Color.fromARGB(255, 40, 39, 41),
      child: ListTile(
        title: Text(
          programName,
          style: const TextStyle(fontSize: 18, color: Color(0xFFF7BB0E)),
        ),
        onTap: () {
          // Handle program selection
        },
      ),
    );
  }
}
