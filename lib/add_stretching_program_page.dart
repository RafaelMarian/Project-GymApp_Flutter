import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStretchingProgramPage extends StatefulWidget {
  const AddStretchingProgramPage({super.key});

  @override
  _AddStretchingProgramPageState createState() => _AddStretchingProgramPageState();
}

class _AddStretchingProgramPageState extends State<AddStretchingProgramPage> {
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  int _selectedTime = 10; // Default time for the program
  final _formKey = GlobalKey<FormState>();

  // Method to add stretching program with time to Firebase Firestore
  Future<void> _addStretchingProgram() async {
    if (_formKey.currentState!.validate()) {
      String exerciseName = _exerciseController.text.trim();
      String description = _descriptionController.text.trim();
      String imageURL = _imageURLController.text.trim();
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        await firestore.collection('stretchingPrograms').add({
          'time': _selectedTime,
          'exercise': exerciseName,
          'description': description,
          'imageURL': imageURL,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exercise "$exerciseName" added for $_selectedTime minutes!')),
        );
        _exerciseController.clear();
        _descriptionController.clear();
        _imageURLController.clear(); // Clear input field after adding
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
        title: const Text('Add Stretching Program'),
        backgroundColor: const Color(0xFF29282C),
      ),
      body: Container(
        color: const Color(0xFF29282C),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Duration for Stretching Program:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              DropdownButton<int>(
                value: _selectedTime,
                dropdownColor: const Color(0xFF29282C),
                items: const [
                  DropdownMenuItem(value: 10, child: Text('10 minutes')),
                  DropdownMenuItem(value: 15, child: Text('15 minutes')),
                  DropdownMenuItem(value: 20, child: Text('20 minutes')),
                  DropdownMenuItem(value: 30, child: Text('30 minutes')),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedTime = newValue ?? 10;
                  });
                },
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: _addStretchingProgram,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7BB0E),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Add Stretching Program'),
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
    super.dispose();
  }
}
