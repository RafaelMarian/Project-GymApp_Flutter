import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTrainingPlanPageGym extends StatefulWidget {
  @override
  _CreateTrainingPlanPageState createState() => _CreateTrainingPlanPageState();
}

class _CreateTrainingPlanPageState extends State<CreateTrainingPlanPageGym> {
  String? clientID;
  String? difficulty;
  String? workoutType;
  String? gender;
  String? selectedDay;
  Map<String, List<Map<String, dynamic>>> days = {}; // Use this to build the daily plan

  // For UI elements
  final List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> workoutTypes = ['Full Body', 'One Muscle Group Per Day', 'Two Muscle Groups Per Day', 'Push Pull Legs', 'Upper Lower'];

  void _addExercise(String day) {
    showDialog(
      context: context,
      builder: (context) {
        String? exerciseName;
        String? reps;
        String? weight;
        String? restTime;

        return AlertDialog(
          title: Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Exercise Name'),
                onChanged: (value) => exerciseName = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                onChanged: (value) => reps = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => weight = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Rest Time (minutes)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => restTime = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (exerciseName != null && reps != null && weight != null && restTime != null) {
                  setState(() {
                    if (!days.containsKey(day)) {
                      days[day] = [];
                    }
                    days[day]?.add({
                      'exercise': exerciseName!,
                      'reps': reps!,
                      'weight': weight!,
                      'restTime': restTime!,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitPlan() async {
    if (clientID == null || clientID!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Client ID is required')));
      return;
    }

    if (difficulty == null || workoutType == null || gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete all fields')));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('training-plans').add({
        'trainerID': 'current_trainer_id', // Replace with actual trainer ID
        'clientID': clientID,
        'difficulty': difficulty,
        'workoutType': workoutType,
        'gender': gender,
        'days': days,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Plan submitted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting plan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Training Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Client ID'),
              onChanged: (value) => clientID = value,
            ),
            DropdownButtonFormField<String>(
              value: difficulty,
              items: difficulties.map((difficulty) {
                return DropdownMenuItem(
                  value: difficulty,
                  child: Text(difficulty),
                );
              }).toList(),
              onChanged: (value) => setState(() => difficulty = value),
              decoration: InputDecoration(labelText: 'Difficulty'),
            ),
            DropdownButtonFormField<String>(
              value: workoutType,
              items: workoutTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) => setState(() => workoutType = value),
              decoration: InputDecoration(labelText: 'Workout Type'),
            ),
            DropdownButtonFormField<String>(
              value: gender,
              items: genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) => setState(() => gender = value),
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            DropdownButtonFormField<String>(
              value: selectedDay,
              items: daysOfWeek.map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                });
                _addExercise(selectedDay!);
              },
              decoration: InputDecoration(labelText: 'Select Day'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: daysOfWeek.length,
                itemBuilder: (context, index) {
                  final day = daysOfWeek[index];
                  final exercises = days[day] ?? [];
                  return ExpansionTile(
                    title: Text(day),
                    children: exercises.map((exercise) {
                      return ListTile(
                        title: Text(exercise['exercise']),
                        subtitle: Text('Reps: ${exercise['reps']}, Weight: ${exercise['weight']}kg, Rest: ${exercise['restTime']} minutes'),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPlan,
              child: Text('Submit Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
