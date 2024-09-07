import 'package:flutter/material.dart';

class PlannedYogaProgramsPage extends StatefulWidget {
  @override
  _PlannedYogaProgramsPageState createState() =>
      _PlannedYogaProgramsPageState();
}

class _PlannedYogaProgramsPageState extends State<PlannedYogaProgramsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planned Yoga Programs'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: ListView(
        padding: EdgeInsets.all(16.0),
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
      color: Colors.grey[700],
      child: ListTile(
        title: Text(
          programName,
          style: TextStyle(fontSize: 18, color: Colors.yellow),
        ),
        onTap: () {
          // Handle program selection
        },
      ),
    );
  }
}
