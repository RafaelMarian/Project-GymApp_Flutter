import 'package:flutter/material.dart';
import 'package:gym_buddies/Boxing/boxing_program_selection_page.dart';
import 'package:gym_buddies/Caliesthenics/calisthenics_program_selection_page.dart';
import 'package:gym_buddies/Swimming/swimming_program_selection_page.dart';
import 'Gym/gym_program_selection_page.dart';
import 'Yoga/yoga_program_selection_page.dart';
import 'Cycling/cycling_program_selection_page.dart';
import 'Jogging/jogging_program_selection_page.dart';
import 'Home-Workout/home_workout_page.dart';


class CustomProgramsPage extends StatelessWidget {
  const CustomProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Programs'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProgramButton(context, 'Gym Program', 'assets/custom-page/gym-program.png', const GymProgramSelectionPage()),
            _buildProgramButton(context, 'Yoga Program', 'assets/custom-page/yoga-program.png', const YogaProgramSelectionPage()),
            _buildProgramButton(context, 'Cycling Program', 'assets/custom-page/cycling-program.png', const CyclingProgramSelectionPage()),
            _buildProgramButton(context, 'Jogging Program', 'assets/custom-page/jogging-program.png', const JoggingProgramSelectionPage()),
            _buildProgramButton(context, 'Calisthenics Program', 'assets/custom-page/caliesthenics-program.png', const CalisthenicsProgramSelectionPage()),
            _buildProgramButton(context, 'Swimming Program', 'assets/custom-page/swimming-program.png', const SwimmingProgramSelectionPage()),
            _buildProgramButton(context, 'Home Workout Program', 'assets/custom-page/home-workout-program.png', const HomeWorkoutPage()),
            _buildProgramButton(context, 'Boxing Program', 'assets/custom-page/boxing-program.png', const BoxingProgramSelectionPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramButton(BuildContext context, String title, String imagePath, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          height: 80, // Adjust the height as needed
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
