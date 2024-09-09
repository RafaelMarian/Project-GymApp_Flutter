import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExerciseGymPage extends StatefulWidget {
  @override
  _AddExerciseGymPageState createState() => _AddExerciseGymPageState();
}

class _AddExerciseGymPageState extends State<AddExerciseGymPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repsController = TextEditingController();
  final _kgController = TextEditingController();
  String? _selectedMuscleGroup;

  Future<void> _addExercise() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final reps = _repsController.text;
    final kg = _kgController.text;
    final muscleGroup = _selectedMuscleGroup;

    if (name.isNotEmpty && description.isNotEmpty && reps.isNotEmpty && kg.isNotEmpty && muscleGroup != null) {
      await FirebaseFirestore.instance.collection('exercises').add({
        'name': name,
        'description': description,
        'reps': reps,
        'kg': kg,
        'muscle_group': muscleGroup, // Add muscle group to Firestore
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercise added successfully')),
      );
      _nameController.clear();
      _descriptionController.clear();
      _repsController.clear();
      _kgController.clear();
      setState(() {
        _selectedMuscleGroup = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exercise'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Exercise Name'),
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.yellow,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.yellow,
            ),
            TextField(
              controller: _repsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Number of Reps'),
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.yellow,
            ),
            TextField(
              controller: _kgController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.yellow,
            ),
            DropdownButton<String>(
              value: _selectedMuscleGroup,
              hint: Text('Select Muscle Group', style: TextStyle(color: Colors.white)),
              dropdownColor: Colors.grey[800],
              items: <String>['Chest', 'Back', 'Biceps', 'Triceps', 'Legs', 'Abs', 'Shoulders']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedMuscleGroup = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
