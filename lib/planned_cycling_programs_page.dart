import 'package:flutter/material.dart';

class PlannedCyclingProgramsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planned Cycling Programs'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Text(
          'Choose from various planned cycling programs!',
          style: TextStyle(fontSize: 18, color: Colors.yellow),
        ),
      ),
    );
  }
}
