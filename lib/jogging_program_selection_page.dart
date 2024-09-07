import 'package:flutter/material.dart';
import 'custom_jogging_program_page.dart';
import 'planned_jogging_programs_page.dart';
import 'my_personal_trainer_plan_page.dart'; // Import MyPersonalTrainerPlanPage

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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo or header for Jogging Programs
            Text(
              'Jogging Programs',
              style: TextStyle(fontSize: 24, color: Colors.yellow),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        builder: (context) => PlannedJoggingProgramsPage(),
                      ),
                    );
                  },
                  child: Text('Planned Jogging Programs'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalTrainerPlanPage(),
                      ),
                    );
                  },
                  child: Text('My Personal Trainer Plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
