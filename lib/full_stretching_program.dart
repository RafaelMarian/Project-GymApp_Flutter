import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FullStretchingProgramPage extends StatefulWidget {
  const FullStretchingProgramPage({super.key});

  @override
  _FullStretchingProgramPageState createState() => _FullStretchingProgramPageState();
}

class _FullStretchingProgramPageState extends State<FullStretchingProgramPage> {
  int? selectedTime;
  List<int> availableTimes = [5, 10, 15, 20];
  List<Map<String, dynamic>> exercises = []; // List to hold exercises from Firestore

  // Fetch exercises based on selected time
  Future<void> _fetchExercises() async {
    if (selectedTime != null) {
      print('Fetching exercises for time: $selectedTime');
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('full_stretching_program')
            .where('time', isEqualTo: selectedTime)
            .get();

        print('Query Snapshot: ${querySnapshot.docs.length} documents found.');

        setState(() {
          exercises = querySnapshot.docs
              .map((doc) => doc.data()) // Get exercise data directly
              .toList();
        });

        if (exercises.isEmpty) {
          print('No exercises found for selected time.');
        }
      } catch (e) {
        print('Error fetching exercises: $e'); // Handle any errors
      }
    } else {
      print('No time selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Stretching Program'),
        backgroundColor: const Color(0xFF29282C),
      ),
      backgroundColor: const Color(0xFF29282C),
      body: Column(
        children: [
          // Dropdown for time selection
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<int>(
              value: selectedTime,
              hint: const Text(
                'Select Time (Minutes)',
                style: TextStyle(color: Colors.white),
              ),
              dropdownColor: const Color(0xFF29282C),
              style: const TextStyle(color: Colors.white),
              items: availableTimes.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value min'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedTime = newValue;
                });
              },
            ),
          ),
          // Button to fetch exercises
          ElevatedButton(
            onPressed: _fetchExercises,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF7BB0E), // Yellow background
            ),
            child: const Text('Fetch Exercises'),
          ),
          // Display the list of exercises
          Expanded(
            child: exercises.isNotEmpty
                ? ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      var exercise = exercises[index]; // Get exercise data directly
                      return Card(
                        color: Colors.grey[850],
                        child: ListTile(
                          title: Text(
                            exercise['name'] ?? 'Unnamed Exercise',
                            style: const TextStyle(color: Color(0xFFF7BB0E)),
                          ),
                          subtitle: Text(
                            exercise['description'] ?? 'No description available',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            '${exercise['time']} min',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No exercises available for the selected time.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
