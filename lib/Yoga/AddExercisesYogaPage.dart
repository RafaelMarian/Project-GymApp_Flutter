import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExerciseYogaPage extends StatefulWidget {
  const AddExerciseYogaPage({super.key});

  @override
  _AddExerciseYogaPageState createState() => _AddExerciseYogaPageState();
}

class _AddExerciseYogaPageState extends State<AddExerciseYogaPage> {
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
        await FirebaseFirestore.instance.collection('default-yoga-exercises').add({
          'name': name,
          'description': description,
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
          const SnackBar(content: Text('Please enter valid numbers')),
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
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
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
                fillColor: Color.fromARGB(255, 66, 66, 66),
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
                fillColor: Color.fromARGB(255, 66, 66, 66),
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
            DropdownButtonFormField<String>(
              value: _selectedMuscleGroup,
              dropdownColor: const Color.fromARGB(255, 66, 66, 66),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 66, 66, 66),
                labelText: 'Select Yoga Program type',
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
              items: ['Hatha', 'Vinyasa', 'Ashtanga', 'Yin', 'Restorative', 'Power']
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
