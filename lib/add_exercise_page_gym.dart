import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExerciseGymPage extends StatefulWidget {
  const AddExerciseGymPage({super.key});

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
    final repsString = _repsController.text;
    final kgString = _kgController.text;
    final muscleGroup = _selectedMuscleGroup;

    if (name.isNotEmpty && description.isNotEmpty && repsString.isNotEmpty && kgString.isNotEmpty && muscleGroup != null) {
      // Convert reps and kg to integers
      final reps = int.tryParse(repsString);
      final kg = int.tryParse(kgString);

      if (reps != null && kg != null) {
        await FirebaseFirestore.instance.collection('exercises').add({
          'name': name,
          'description': description,
          'reps': reps,  // Store as integer
          'kg': kg,      // Store as integer
          'muscle_group': muscleGroup,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise added successfully')),
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
          const SnackBar(content: Text('Please enter valid numbers for reps and weight')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
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
              style: const TextStyle(color: Colors.white),
              cursorColor: const Color(0xFFF7BB0E),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
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
              cursorColor: const Color(0xFFF7BB0E),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Reps',
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
              cursorColor: const Color(0xFFF7BB0E),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _kgController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
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
              style: const TextStyle(color: Colors.white),
              cursorColor: const Color(0xFFF7BB0E),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedMuscleGroup,
              hint: const Text('Select Muscle Group', style: TextStyle(color: Colors.white)),
              dropdownColor: Colors.black,
              items: <String>['Chest', 'Back', 'Biceps', 'Triceps', 'Legs', 'Abs', 'Shoulders']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedMuscleGroup = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E),
              ),
              child: const Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
