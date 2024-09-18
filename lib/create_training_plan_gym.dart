import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure this import is present
import 'dart:convert'; // Import this for JSON encoding/decoding

class CreateTrainingPlanPageGym extends StatefulWidget {
  const CreateTrainingPlanPageGym({super.key});

  @override
  _CreateTrainingPlanPageState createState() => _CreateTrainingPlanPageState();
}

class _CreateTrainingPlanPageState extends State<CreateTrainingPlanPageGym> {
  String? clientID;
  String? clientName; // Separate variable for client name
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
        const SnackBar(content: Text('Client ID is required')),
      );
      return;
    }

    // Populate the days map with exercises for each day
    days[selectedDay] = exercises;

    try {
      await FirebaseFirestore.instance.collection('training-plans').add({
        'trainerID': 'current_trainer_id', // Replace with actual trainer ID
        'clientID': clientID, // Use clientID not clientName
        'clientName': clientName, // Store clientName separately
        'difficulty': difficulty,
        'workoutType': workoutType,
        'gender': gender,
        'days': days,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plan submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting plan')),
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
        title: const Text('Create Training Plan'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41), // Background color for the whole app
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => clientID = value,
              decoration: InputDecoration(
                labelText: 'Client ID',
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: Color(0xFFF7BB0E),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) => clientName = value, // Update clientName, not clientID
              decoration: InputDecoration(
                labelText: 'Client Name',
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: Color(0xFFF7BB0E),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: difficulty,
              hint: const Text('Select Difficulty', style: TextStyle(color: Colors.white)),
              dropdownColor: Colors.black,
              items: ['Beginner', 'Intermediate', 'Advanced']
                  .map((difficulty) => DropdownMenuItem<String>(
                        value: difficulty,
                        child: Text(difficulty, style: TextStyle(color: Colors.white)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  difficulty = value;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: workoutType,
              hint: const Text('Select Workout Type', style: TextStyle(color: Colors.white)),
              dropdownColor: Colors.black,
              items: [
                'Full Body',
                'One Muscle Group Per Day',
                'Two Muscle Groups Per Day',
                'Push Pull Legs',
                'Upper Lower'
              ]
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type, style: TextStyle(color: Colors.white)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  workoutType = value;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: gender,
              hint: const Text('Select Gender', style: TextStyle(color: Colors.white)),
              dropdownColor: Colors.black,
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender, style: TextStyle(color: Colors.white)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedDay,
              hint: const Text('Select Day of the Week', style: TextStyle(color: Colors.white)),
              dropdownColor: Colors.black,
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
                        child: Text(day, style: TextStyle(color: Colors.white)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDay = value!;
                  _loadExercises();
                });
              },
            ),
            const SizedBox(height: 10),
            // Align the buttons to the right using a Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _deleteAllExercises,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 0, 0),
                  ),
                  child: const Text('Delete All Exercises'),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteExercise(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Align the buttons to the right using a Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                          title: const Text('Add Exercise'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                onChanged: (value) => exerciseName = value,
                                decoration: InputDecoration(
                                  labelText: 'Exercise Name',
                                  filled: true,
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                onChanged: (value) => reps = int.tryParse(value) ?? 0,
                                decoration: InputDecoration(
                                  labelText: 'Reps',
                                  filled: true,
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                onChanged: (value) => weight = double.tryParse(value) ?? 0.0,
                                decoration: InputDecoration(
                                  labelText: 'Weight (kg)',
                                  filled: true,
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                onChanged: (value) => restTime = int.tryParse(value) ?? 0,
                                decoration: InputDecoration(
                                  labelText: 'Rest Time (s)',
                                  filled: true,
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                _addExercise(exerciseName, reps, weight, restTime);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF7BB0E),
                  ),
                  child: const Text('Add Exercise'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _submitPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF7BB0E),
                  ),
                  child: const Text('Submit Plan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
