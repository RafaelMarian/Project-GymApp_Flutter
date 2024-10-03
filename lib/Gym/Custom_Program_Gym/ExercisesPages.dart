import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExercisesPage extends StatefulWidget {
  final String muscleGroup;
  const ExercisesPage({required this.muscleGroup});

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  List<Map<String, dynamic>> exercises = [];
  int? selectedExerciseIndex; // To track the selected exercise index

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
        final data = doc.data();
        return data;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.muscleGroup} Exercises'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41), // Dark grey background
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          bool isSelected = selectedExerciseIndex == index; // Check if this exercise is selected

          return GestureDetector(
            onTap: () {
              setState(() {
                // Toggle the selection of the exercise
                selectedExerciseIndex = isSelected ? null : index; // Deselect if already selected
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
                    // Show image on the top when selected
                    if (isSelected)
                      SizedBox(
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
                    // Exercise name
                    Text(
                      exercise['name'],
                      style: const TextStyle(color: Color(0xFFF7BB0E), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Show additional info if selected
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
                      Text(
                        'Weight: ${exercise['kg']} kg',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                    // Show image on the right side if not selected
                    if (!isSelected)
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 60,
                          child: Image.asset(
                            'assets/${exercise['name'].toLowerCase().replaceAll(' ', '_')}.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 60,
                                child: Center(child: Text('No Image', style: TextStyle(color: Colors.white))),
                              );
                            },
                          ),
                        ),
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
