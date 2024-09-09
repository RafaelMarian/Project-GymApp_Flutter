import 'package:flutter/material.dart';
import 'custom_gym_program_page.dart';
import 'planned_gym_programs_page.dart';
import 'my_personal_trainer_plan_gym_page.dart'; // Import Personal Trainer Plan page
import 'add_exercise_page_gym.dart'; // Import AddExercisePage

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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: Size(200, 50),
              ),
              child: Text('Custom Program'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlannedGymProgramsPage(),
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
                    builder: (context) => MyPersonalTrainerPlanGymPage(), // Navigate to "My Personal Trainer Plan"
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: Size(200, 50),
              ),
              child: Text('My Personal Trainer Plan'),
            ),
            SizedBox(height: 20),
            ElevatedButton( // New button for adding an exercise
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExerciseGymPage(), // Navigate to AddExercisePage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: Size(200, 50),
              ),
              child: Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
