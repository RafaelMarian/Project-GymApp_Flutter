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

    if (name.isNotEmpty &&
        description.isNotEmpty &&
        repsString.isNotEmpty &&
        kgString.isNotEmpty &&
        muscleGroup != null) {
      // Convert reps and kg to integers
      final reps = int.tryParse(repsString);
      final kg = int.tryParse(kgString);

      if (reps != null && kg != null) {
        await FirebaseFirestore.instance.collection('default-gym-exercises').add({
          'name': name,
          'description': description,
          'reps': reps,
          'kg': kg,
          'muscle_group': muscleGroup,
          'completed': false, // Default value for 'completed'
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
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF121212),
      body: Container(
        
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                filled: true,
                fillColor: Color(0xFF2A2A2A),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                  borderSide: BorderSide.none, // No outline when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                  borderSide: BorderSide.none, // No outline when focused
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
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
                labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                filled: true,
                fillColor: Color(0xFF2A2A2A),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                  borderSide: BorderSide.none, // No outline when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                  borderSide: BorderSide.none, // No outline when focused
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: const Color(0xFFF7BB0E),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                        borderSide: BorderSide.none, // No outline when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                        borderSide: BorderSide.none, // No outline when focused
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: const Color(0xFFF7BB0E),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _kgController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                        borderSide: BorderSide.none, // No outline when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                        borderSide: BorderSide.none, // No outline when focused
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: const Color(0xFFF7BB0E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedMuscleGroup,
              dropdownColor: const Color(0xFF2A2A2A),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFF2A2A2A),
                labelText: 'Select Muscle Group',
                labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                  borderSide: BorderSide.none, // No outline when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)), // Rounded corners
                  borderSide: BorderSide.none, // No outline when focused
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['Chest', 'Back', 'Biceps', 'Triceps', 'Legs', 'Abs', 'Shoulders']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.white)), // Ensure text color is white
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedMuscleGroup = newValue;
                });
              },
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Exercise',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
