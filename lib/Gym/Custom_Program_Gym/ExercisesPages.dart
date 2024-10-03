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
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      body: Container(
        color: const Color.fromARGB(255, 40, 39, 41),
        child: exercises.isNotEmpty
            ? ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];

                  return Card(
                    color: Colors.grey[850], // Dark color for the card
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise['name'],
                            style: const TextStyle(
                              color: Color(0xFFF7BB0E), // Yellow title text
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            exercise['description'],
                            style: const TextStyle(color: Colors.white70), // Light grey description text
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Reps: ${exercise['reps']}',
                            style: const TextStyle(color: Colors.white), // White text for reps
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Weight: ${exercise['kg']} kg',
                            style: const TextStyle(color: Colors.white), // White text for weight
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(), // Show a loader while fetching exercises
              ),
      ),
    );
  }
}
