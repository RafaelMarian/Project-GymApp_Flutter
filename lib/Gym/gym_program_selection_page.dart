import 'package:flutter/material.dart';
import 'Custom_Program_Gym/custom_gym_program_page.dart';
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
       title: const Center(
        child: Text(
         'Gym Program Selection',
         style: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255), // White text color
        fontSize: 24, // Adjust font size if needed
      ),
    ),
  ),
  backgroundColor: const Color.fromARGB(255, 40, 39, 41), // Custom background color
),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
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
                backgroundColor: const Color(0xFFF7BB0E),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                  'Custom Programs',
                  style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), // You can change this to any color you want
                  fontSize: 14, // Adjust the font size as needed // Optional: Set font weight to bold
                ),
              ),
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
                backgroundColor: const Color(0xFFF7BB0E),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                 'Planned Programs',
                  style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), // You can change this to any color you want
                  fontSize: 14, // Adjust the font size as needed // Optional: Set font weight to bold
                ),
              ),
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
                backgroundColor: const Color(0xFFF7BB0E),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                  'My Personal Trainer Plan',
                  style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), // You can change this to any color you want
                  fontSize: 14, // Adjust the font size as needed // Optional: Set font weight to bold
                ),
              ),
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
                backgroundColor: const Color(0xFFF7BB0E),
                minimumSize: const Size(200, 50),
              ),
             child: const Text(
                 'Add Exercise',
                 style: TextStyle(
                 color: Color.fromARGB(255, 0, 0, 0), // You can change this to any color you want
                  fontSize: 14, // Adjust the font size as needed
                ),
              ),
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
                backgroundColor: const Color(0xFFF7BB0E),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Create Training Plan',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), // You can change this to any color you want
                 fontSize: 14, // Adjust the font size as needed // Optional: Set font weight to bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
