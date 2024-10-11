import 'package:flutter/material.dart';
import 'package:gym_buddies/Boxing/Custom_Program_Boxing/ExercisesPagesBoxing.dart';
import 'SlideRightRoutePageJogging.dart';

class CustomCalisthenicsProgramPage extends StatefulWidget {
  const CustomCalisthenicsProgramPage({super.key});

  @override
  _CustomCalisthenicsProgramPageState createState() => _CustomCalisthenicsProgramPageState();
}

class _CustomCalisthenicsProgramPageState extends State<CustomCalisthenicsProgramPage> {
  String? selectedMuscleGroup;
  List<Map<String, dynamic>> defaultExercises = [];
  List<Map<String, dynamic>> userExercises = [];

  void _selectMuscleGroup(String group) {
    setState(() {
      selectedMuscleGroup = group;
      Navigator.push(
        context,
        SlideRightRouteJogging(
          widget: ExercisesPageBoxing(muscleGroup: group),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final muscleGroups = [
      {'name': 'Chest', 'image': 'assets/chest-workout-gym.png'},
      {'name': 'Back', 'image': 'assets/back-workout-gym.png'},
      {'name': 'Biceps', 'image': 'assets/biceps-workout-gym.png'},
      {'name': 'Triceps', 'image': 'assets/triceps-workout-gym.png'},
      {'name': 'Legs', 'image': 'assets/legs-workout-gym.png'},
      {'name': 'Abs', 'image': 'assets/abs-workout-gym.png'},
      {'name': 'Shoulders', 'image': 'assets/shoulders-workout-gym.png'}
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Gym Program'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      // Set the background color of the page here
      backgroundColor: const Color.fromARGB(255, 40, 39, 41), // <-- Added this
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of boxes per row
          childAspectRatio: 1, // Aspect ratio for the boxes
        ),
        itemCount: muscleGroups.length,
        itemBuilder: (context, index) {
          final muscleGroup = muscleGroups[index];
          return GestureDetector(
            onTap: () {
              _selectMuscleGroup(muscleGroup['name']!);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(muscleGroup['image']!),
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
                muscleGroup['name']!,
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
          );
        },
      ),
    );
  }
}
