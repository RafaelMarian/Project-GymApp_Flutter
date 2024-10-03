import 'package:flutter/material.dart';
import 'Gym/gym_program_selection_page.dart';
import 'Yoga/yoga_program_selection_page.dart';
import 'Cycling/cycling_program_selection_page.dart';
import 'Jogging/jogging_program_selection_page.dart';
import 'Caliesthenics/calisthenics_program_page.dart';
import 'Swimming/swimming_program_page.dart';
import 'Home-Workout/home_workout_page.dart';
import 'Boxing/boxing_program_page.dart';

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
            _buildProgramButton(context, 'Gym Program', const GymProgramSelectionPage()),
            _buildProgramButton(context, 'Yoga Program', const YogaProgramSelectionPage()),
            _buildProgramButton(context, 'Cycling Program', const CyclingProgramSelectionPage()),
            _buildProgramButton(context, 'Jogging Program', const JoggingProgramSelectionPage()),
            _buildProgramButton(context, 'Calisthenics Program', const CalisthenicsProgramPage()),
            _buildProgramButton(context, 'Swimming Program', const SwimmingProgramPage()),
            _buildProgramButton(context, 'Home Workout Program', const HomeWorkoutPage()),
            _buildProgramButton(context, 'Boxing Program', const BoxingProgramPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramButton(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF7BB0E),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
