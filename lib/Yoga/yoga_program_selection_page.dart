import 'package:flutter/material.dart';
import 'package:gym_buddies/Yoga/AddExercisesYogaPage.dart';
import 'package:gym_buddies/Yoga/CreateTrainingPlanPageYoga.dart';
import 'package:gym_buddies/Yoga/Custom_Program_Yoga/custom_yoga_program_page.dart';
import 'package:gym_buddies/Yoga/my_personal_trainer_plan_yoga_page.dart';
import 'package:gym_buddies/Yoga/planned_yoga_programs_page.dart';


class YogaProgramSelectionPage extends StatefulWidget {
  const YogaProgramSelectionPage({super.key});

  @override
  _YogaProgramSelectionPageState createState() =>
      _YogaProgramSelectionPageState();
}

class _YogaProgramSelectionPageState extends State<YogaProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yoga Program Selection',
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
                  const CustomYogaProgramPage(),
                ),
                _buildProgramButton(
                  context,
                  'Planned Programs',
                  Icons.calendar_today,
                  const PlannedYogaProgramsPage(),
                ),
                _buildProgramButton(
                  context,
                  'My Personal Trainer Plan',
                  Icons.person,
                  const MyPersonalTrainerPlanYogaPage(),
                ),
                _buildProgramButton(
                  context,
                  'Add Exercise',
                  Icons.add,
                  const AddExerciseYogaPage(),
                ),
                _buildProgramButton(
                  context,
                  'Create Training Plan',
                  Icons.create,
                  const CreateTrainingPlanPageYoga(),
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
