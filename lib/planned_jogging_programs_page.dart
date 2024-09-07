import 'package:flutter/material.dart';

class PlannedJoggingProgramsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planned Jogging Programs'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Text(
          'Planned Jogging Programs Page',
          style: TextStyle(color: Colors.yellow, fontSize: 24),
        ),
      ),
    );
  }
}
