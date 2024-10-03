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
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ListTile(
            title: Text(exercise['name']),
            subtitle: Text(exercise['description']),
          );
        },
      ),
    );
  }
}
