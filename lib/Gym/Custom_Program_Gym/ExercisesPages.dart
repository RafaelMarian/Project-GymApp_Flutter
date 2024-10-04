import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_buddies/Create_Yout_Workout_Day.dart'; // Import the WorkoutPage

class ExercisesPage extends StatefulWidget {
  final String muscleGroup;
  const ExercisesPage({super.key, required this.muscleGroup});

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  List<Map<String, dynamic>> exercises = [];
  int? selectedExerciseIndex;

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    final exercisesSnapshot = await FirebaseFirestore.instance
        .collection('default-gym-exercises')
        .where('muscle_group', isEqualTo: widget.muscleGroup)
        .get();

    setState(() {
      exercises = exercisesSnapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> _addToWorkout(Map<String, dynamic> exercise) async {
    // Add the selected exercise to Firebase for the workout program
    await FirebaseFirestore.instance.collection('user-workout-programs').add({
      'name': exercise['name'],
      'reps': exercise['reps'],
      'kg': exercise['kg'],
      'description': exercise['description'],
      'image': exercise['image'] ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Optionally navigate to CreateYourWorkoutPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  CreateYourWorkoutDay(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.muscleGroup} Exercises'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          bool isSelected = selectedExerciseIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedExerciseIndex = isSelected ? null : index;
              });
            },
            child: Card(
              color: Colors.grey[850],
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isSelected)
                      Center(
                        child: SizedBox(
                          height: 200,
                          child: Image.asset(
                            'assets/${exercise['name'].toLowerCase().replaceAll(' ', '_')}.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text('No Image', style: TextStyle(color: Colors.white)),
                              );
                            },
                          ),
                        ),
                      ),
                    Text(
                      exercise['name'],
                      style: const TextStyle(color: Color(0xFFF7BB0E), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (isSelected) ...[
                      Text(
                        exercise['description'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Reps: ${exercise['reps']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Weight: ${exercise['kg']} kg',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _addToWorkout(exercise),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7BB0E),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('➕ Add to Workout'),
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
