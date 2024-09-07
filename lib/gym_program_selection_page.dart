import 'package:flutter/material.dart';
import 'custom_gym_program_page.dart'; // Import CustomGymProgramPage
import 'planned_gym_programs_page.dart'; // Import PlannedGymProgramsPage

class GymProgramSelectionPage extends StatefulWidget {
  @override
  _GymProgramSelectionPageState createState() =>
      _GymProgramSelectionPageState();
}

class _GymProgramSelectionPageState extends State<GymProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Program Selection'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomGymProgramPage(),
                ),
              );
            },
            child: Text('Custom'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlannedGymProgramsPage(),
                ),
              );
            },
            child: Text('Planned Gym Programs'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }
}
