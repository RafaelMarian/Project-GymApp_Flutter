import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CreateTrainingPlanPageGym extends StatefulWidget {
  const CreateTrainingPlanPageGym({super.key});

  @override
  _CreateTrainingPlanPageState createState() => _CreateTrainingPlanPageState();
}

class _CreateTrainingPlanPageState extends State<CreateTrainingPlanPageGym> {
  String? clientID;
  String? clientName;
  String? difficulty;
  String? workoutType;
  String? gender;
  Map<String, dynamic> days = {};
  String selectedDay = 'Monday';
  List<Map<String, dynamic>> exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final prefs = await SharedPreferences.getInstance();
    for (String day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']) {
      final savedExercises = prefs.getString('exercises_$day') ?? '[]';
      days[day] = List<Map<String, dynamic>>.from(jsonDecode(savedExercises));
    }
    setState(() {
      exercises = days[selectedDay] ?? [];
    });
  }

  Future<void> _saveExercises() async {
    final prefs = await SharedPreferences.getInstance();
    for (String day in days.keys) {
      prefs.setString('exercises_$day', jsonEncode(days[day]));
    }
  }

  Future<void> _submitPlan() async {
    if (clientID == null || clientID!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client ID is required')),
      );
      return;
    }

    days[selectedDay] = exercises;

    try {
      await FirebaseFirestore.instance.collection('training-plans').add({
        'trainerID': 'current_trainer_id',
        'clientID': clientID,
        'clientName': clientName,
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
      days[selectedDay] = exercises;
      _saveExercises();
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      exercises.removeAt(index);
      days[selectedDay] = exercises;
      _saveExercises();
    });
  }

  void _deleteAllExercises() {
    setState(() {
      exercises.clear();
      days[selectedDay] = exercises;
      _saveExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Training Plan', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 40, 39, 41), Color.fromARGB(255, 40, 39, 41)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField('Client ID', onChanged: (value) => clientID = value),
                const SizedBox(height: 16),
                _buildTextField('Client Name', onChanged: (value) => clientName = value),
                const SizedBox(height: 16),
                _buildDropdown(
                  'Select Difficulty',
                  ['Beginner', 'Intermediate', 'Advanced'],
                  value: difficulty,
                  onChanged: (value) => setState(() => difficulty = value),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  'Select Workout Type',
                  ['Full Body', 'One Muscle Group Per Day', 'Two Muscle Groups Per Day', 'Push Pull Legs', 'Upper Lower'],
                  value: workoutType,
                  onChanged: (value) => setState(() => workoutType = value),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  'Select Gender',
                  ['Male', 'Female',],
                  value: gender,
                  onChanged: (value) => setState(() => gender = value),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  'Select Day of the Week',
                  ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                  value: selectedDay,
                  onChanged: (value) => setState(() {
                    selectedDay = value!;
                    exercises = List<Map<String, dynamic>>.from(days[selectedDay] ?? []);
                  }),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _deleteAllExercises,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Delete All Exercises', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () => _showAddExerciseDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7BB0E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Exercise', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildExerciseCards(), // Updated to use exercise cards
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitPlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7BB0E),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Plan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildTextField(String label, {required ValueChanged<String> onChanged}) {
  return TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: const Color.fromARGB(255, 66, 66, 66),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Keep the corners rounded
        borderSide: BorderSide.none, // No outline when enabled
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Keep the corners rounded
        borderSide: BorderSide.none, // No outline when focused
      ),
    ),
    style: const TextStyle(color: Colors.white),
    cursorColor: const Color(0xFFF7BB0E),
  );
}

Widget _buildDropdown(
    String hint,
    List<String> items, {
    String? value,
    required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(255, 66, 66, 66),
      labelText: hint,
      labelStyle: const TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Keep the corners rounded
        borderSide: BorderSide.none, // No outline
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Keep the corners rounded
        borderSide: BorderSide.none, // No outline when enabled
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Keep the corners rounded
        borderSide: BorderSide.none, // No outline when focused
      ),
    ),
    dropdownColor: const Color.fromARGB(255, 66, 66, 66),
    style: const TextStyle(color: Colors.white),
    items: items.map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item, style: const TextStyle(color: Colors.white)),
      );
    }).toList(),
    onChanged: onChanged,
  );
}
   // Function to create the exercise cards
  Widget _buildExerciseCards() {
    if (exercises.isEmpty) {
      return const Center(
        child: Text(
          'No exercises added for this day.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling for the list
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          color: const Color.fromARGB(255, 66, 66, 66),
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise['name'],
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Reps: ${exercise['reps']}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Weight: ${exercise['weight']} kg',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Rest Time: ${exercise['restTime']} sec',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteExercise(index),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show dialog for adding a new exercise
  void _showAddExerciseDialog(BuildContext context) {
    String exerciseName = '';
    int reps = 0;
    double weight = 0.0;
    int restTime = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Exercise Name', onChanged: (value) => exerciseName = value),
              const SizedBox(height: 16),
              _buildTextField('Reps', onChanged: (value) => reps = int.tryParse(value) ?? 0),
              const SizedBox(height: 16),
              _buildTextField('Weight (kg)', onChanged: (value) => weight = double.tryParse(value) ?? 0.0),
              const SizedBox(height: 16),
              _buildTextField('Rest Time (sec)', onChanged: (value) => restTime = int.tryParse(value) ?? 0),
            ],
          ),
          actions: [
            TextButton(
  onPressed: () {
    Navigator.of(context).pop();
  },
  style: TextButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Set the text color
  ),
  child: const Text('Cancel'),
),

            ElevatedButton(
  onPressed: () {
    _addExercise(exerciseName, reps, weight, restTime);
    Navigator.of(context).pop();
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFF7BB0E), // Set the background color
    foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Set the text color
  ),
  child: const Text('Add'),
),

          ],
        );
      },
    );
  }
}

