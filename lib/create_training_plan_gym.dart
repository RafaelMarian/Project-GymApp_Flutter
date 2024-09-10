import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure this import is present
import 'dart:convert'; // Import this for JSON encoding/decoding

class CreateTrainingPlanPageGym extends StatefulWidget {
  @override
  _CreateTrainingPlanPageState createState() => _CreateTrainingPlanPageState();
}

class _CreateTrainingPlanPageState extends State<CreateTrainingPlanPageGym> {
  String? clientID;
  String? difficulty;
  String? workoutType;
  String? gender;
  Map<String, dynamic> days = {}; // Use this to build the daily plan
  String selectedDay = 'Monday'; // Default selected day
  List<Map<String, dynamic>> exercises = []; // Exercises for the selected day

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final savedExercises = prefs.getString('exercises_$selectedDay') ?? '[]';
    setState(() {
      exercises = List<Map<String, dynamic>>.from(jsonDecode(savedExercises));
    });
  }

  Future<void> _saveExercises() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('exercises_$selectedDay', jsonEncode(exercises));
  }

  Future<void> _submitPlan() async {
    if (clientID == null || clientID!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Client ID is required')),
      );
      return;
    }

    // Populate the days map with exercises for each day
    days[selectedDay] = exercises;

    try {
      await FirebaseFirestore.instance.collection('training-plans').add({
        'trainerID': 'current_trainer_id', // Replace with actual trainer ID
        'clientID': clientID,
        'difficulty': difficulty,
        'workoutType': workoutType,
        'gender': gender,
        'days': days,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Plan submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting plan')),
      );
    }
  }

  void _addExercise(String exerciseName, int reps, double weight, int restTime) {
    setState(() {
      exercises.add({
        'name': exerciseName,
        'reps': reps,
        'weight': weight,
        'restTime': restTime,
      });
      _saveExercises();
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      exercises.removeAt(index);
      _saveExercises();
    });
  }

  void _deleteAllExercises() {
    setState(() {
      exercises.clear();
      _saveExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Training Plan'),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => clientID = value,
              decoration: InputDecoration(
                labelText: 'Client ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) => clientID = value,
              decoration: InputDecoration(
                labelText: 'Client Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: difficulty,
              hint: Text('Select Difficulty'),
              items: ['Beginner', 'Intermediate', 'Advanced']
                  .map((difficulty) => DropdownMenuItem<String>(
                        value: difficulty,
                        child: Text(difficulty),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  difficulty = value;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: workoutType,
              hint: Text('Select Workout Type'),
              items: [
                'Full Body',
                'One Muscle Group Per Day',
                'Two Muscle Groups Per Day',
                'Push Pull Legs',
                'Upper Lower'
              ]
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  workoutType = value;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: gender,
              hint: Text('Select Gender'),
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedDay,
              hint: Text('Select Day of the Week'),
              items: [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday'
              ]
                  .map((day) => DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDay = value!;
                  _loadExercises();
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteAllExercises,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text('Delete All Exercises'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    title: Text(exercise['name']),
                    subtitle: Text(
                        'Reps: ${exercise['reps']}, Weight: ${exercise['weight']}kg, Rest: ${exercise['restTime']}s'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteExercise(index),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add a new exercise dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    String exerciseName = '';
                    int reps = 0;
                    double weight = 0.0;
                    int restTime = 0;
                    return AlertDialog(
                      title: Text('Add Exercise'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            onChanged: (value) => exerciseName = value,
                            decoration: InputDecoration(
                              labelText: 'Exercise Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) => reps = int.tryParse(value) ?? 0,
                            decoration: InputDecoration(
                              labelText: 'Reps',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) => weight = double.tryParse(value) ?? 0.0,
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) => restTime = int.tryParse(value) ?? 0,
                            decoration: InputDecoration(
                              labelText: 'Rest Time (s)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _addExercise(exerciseName, reps, weight, restTime);
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text('Add Exercise'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitPlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text('Submit Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
