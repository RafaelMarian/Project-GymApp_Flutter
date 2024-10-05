import 'package:flutter/material.dart';
import 'Custom_Program_Gym/custom_gym_program_page.dart';
import 'planned_gym_programs_page.dart';
import 'my_personal_trainer_plan_gym_page.dart'; 
import 'add_exercise_page_gym.dart'; 
import 'create_training_plan_gym.dart'; 

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
        title: const Text(
          'Gym Program Selection',
          style: TextStyle(
            color: Colors.white, // White text color
            fontSize: 24, // Font size
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 39, 41), // Dark background color
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 40, 39, 41), Color.fromARGB(255, 0, 0, 0)], // Subtle gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProgramButton(
                  context,
                  'Custom Programs',
                  Icons.fitness_center,
                  const CustomGymProgramPage(),
                ),
                _buildProgramButton(
                  context,
                  'Planned Programs',
                  Icons.calendar_today,
                  const PlannedGymProgramsPage(),
                ),
                _buildProgramButton(
                  context,
                  'My Personal Trainer Plan',
                  Icons.person,
                  const MyPersonalTrainerPlanPageGym(),
                ),
                _buildProgramButton(
                  context,
                  'Add Exercise',
                  Icons.add,
                  const AddExerciseGymPage(),
                ),
                _buildProgramButton(
                  context,
                  'Create Training Plan',
                  Icons.create,
                  const CreateTrainingPlanPageGym(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable button builder function
  Widget _buildProgramButton(BuildContext context, String title, IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0), // Spacing between buttons
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for card
          ),
          color: const Color(0xFFF7BB0E), // Custom button color
          elevation: 5, // Elevation for depth effect
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.black, size: 24), // Icon on button
                const SizedBox(width: 10), // Spacing between icon and text
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black, // Black text color
                    fontSize: 16, // Adjusted font size
                    fontWeight: FontWeight.bold, // Bold font weight
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
