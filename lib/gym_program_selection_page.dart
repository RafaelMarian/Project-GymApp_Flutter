import 'package:flutter/material.dart';
import 'custom_gym_program_page.dart';
import 'planned_gym_programs_page.dart';
import 'my_personal_trainer_plan_gym_page.dart'; // Import Personal Trainer Plan page
import 'add_exercise_page_gym.dart'; // Import AddExercisePage
import 'create_training_plan_gym.dart'; // Import CreateTrainingPlanGymPage

class GymProgramSelectionPage extends StatefulWidget {
  const GymProgramSelectionPage({super.key});

  @override
  _GymProgramSelectionPageState createState() =>
      _GymProgramSelectionPageState();
}

class _GymProgramSelectionPageState extends State<GymProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Program Selection'),
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
                    builder: (context) => const CustomGymProgramPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Custom Program'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlannedGymProgramsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Planned Programs'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyPersonalTrainerPlanPageGym(), // Navigate to "My Personal Trainer Plan"
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('My Personal Trainer Plan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton( // Button for adding an exercise
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddExerciseGymPage(), // Navigate to AddExercisePage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Add Exercise'),
            ),
            const SizedBox(height: 20),
            ElevatedButton( // New button for Create Training Plan
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTrainingPlanPageGym(), // Navigate to CreateTrainingPlanGymPage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Create Training Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
