import 'package:flutter/material.dart';
import 'package:gym_buddies/Cycling/planned_cycling_programs_page_Indoor.dart';
import 'package:gym_buddies/Cycling/planned_cycling_programs_page_Outdoor.dart';

class CyclingProgramSelectionPage extends StatefulWidget {
  const CyclingProgramSelectionPage({super.key});

  @override
  _CyclingProgramSelectionPageState createState() =>
      _CyclingProgramSelectionPageState();
}

class _CyclingProgramSelectionPageState
    extends State<CyclingProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cycling Program Selection',
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
            colors: [
              Color.fromARGB(255, 40, 39, 41),
              Color.fromARGB(255, 0, 0, 0)
            ], // Subtle gradient
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
                  'Planned Programs Indoor',
                  Icons.fitness_center_sharp,
                  const PlannedCyclingProgramsPageIndoor(),
                  'assets/cycling/cycling-indoor.png', // Indoor background image
                ),
                _buildProgramButton(
                  context,
                  'Planned Programs Outdoor',
                  Icons.fitness_center_sharp,
                  const PlannedCyclingProgramsPageOutdoor(),
                  'assets/cycling/cycling-outdoor.png', // Outdoor background image
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable button builder function with background image parameter
  Widget _buildProgramButton(BuildContext context, String title, IconData icon, Widget nextPage, String backgroundImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Increases vertical padding
      child: InkWell(
        onTap: () {
          // Navigates to the next page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        child: Container(
          height: 275, // Increased height
          width: double.infinity, // Full width button
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage), // Custom background image for each button
              fit: BoxFit.cover, // Makes the image cover the entire button
            ),
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white), // Larger icon
              const SizedBox(width: 16), // Space between icon and text
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20, // Larger text size
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
