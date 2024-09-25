import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Method to add exercise to Firebase Firestore
  Future<void> _addExercise() async {
    if (_formKey.currentState!.validate()) {
      String exerciseName = _exerciseController.text.trim();
      String description = _descriptionController.text.trim();
      String imageURL = _imageURLController.text.trim();
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        await firestore.collection('stretchingExercises').add({
          'exercise': exerciseName,
          'description': description,
          'imageURL': imageURL,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exercise "$exerciseName" added!')),
        );
        _exerciseController.clear();
        _descriptionController.clear();
        _imageURLController.clear(); // Clear fields after adding
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add exercise: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stretching Exercise'),
        backgroundColor: const Color(0xFF29282C),
      ),
      body: Container(
        color: const Color(0xFF29282C),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _exerciseController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Exercise Name',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF7BB0E)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Exercise Description',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF7BB0E)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _imageURLController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF7BB0E)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
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
      ),
    );
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _descriptionController.dispose();
    _imageURLController.dispose();
    super.dispose();
  }
}
