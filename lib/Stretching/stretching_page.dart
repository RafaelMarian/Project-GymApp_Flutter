import 'package:flutter/material.dart';
import 'full_stretching_program.dart';
import 'stretching_exercises_page.dart';

class StretchingPage extends StatelessWidget {
  const StretchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stretching'),
        backgroundColor: const Color(0xFF29282C), // Dark background
      ),
      body: Container(
        color: const Color(0xFF29282C), // Dark background
        padding: const EdgeInsets.all(16.0),
        width: double.infinity, // Ensure the container takes the full width
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose your Stretching Program:',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _navigateToFullStretchingProgram(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Full Stretching Program',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _navigateToStretchingExercises(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Stretching Exercises',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to Full Stretching Program Page
  void _navigateToFullStretchingProgram(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FullStretchingProgramPage(),
      ),
    );
  }

  // Navigate to Stretching Exercises List Page
  void _navigateToStretchingExercises(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StretchingExercisesPage(),
      ),
    );
  }
}
