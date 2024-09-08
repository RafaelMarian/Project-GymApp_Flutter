import 'package:flutter/material.dart';
import 'custom_jogging_program_page.dart';
import 'planned_jogging_programs_page.dart';
import 'my_personal_trainer_plan_page.dart'; // Import the new "My Personal Trainer Plan" page

class JoggingProgramSelectionPage extends StatefulWidget {
  @override
  _JoggingProgramSelectionPageState createState() =>
      _JoggingProgramSelectionPageState();
}

class _JoggingProgramSelectionPageState
    extends State<JoggingProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogging Program Selection'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center( // Center the content
        child: Column(
          mainAxisSize: MainAxisSize.min, // Align the column in the center vertically
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomJoggingProgramPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: Size(200, 50), // Set the same size for all buttons
              ),
              child: Text('Custom Program'),
            ),
            SizedBox(height: 20), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlannedJoggingProgramsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: Size(200, 50),
              ),
              child: Text('Planned Programs'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalTrainerPlanPage(), // Navigate to "My Personal Trainer Plan" page
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: Size(200, 50),
              ),
              child: Text('My Personal Trainer Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
