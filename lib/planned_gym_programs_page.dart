import 'package:flutter/material.dart';

class PlannedGymProgramsPage extends StatefulWidget {
  @override
  _PlannedGymProgramsPageState createState() => _PlannedGymProgramsPageState();
}

class _PlannedGymProgramsPageState extends State<PlannedGymProgramsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planned Gym Programs'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Text('Planned Gym Programs Page Content'),
      ),
    );
  }
}
