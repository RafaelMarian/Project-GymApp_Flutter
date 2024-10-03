import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StretchingExercisesPage extends StatefulWidget {
  const StretchingExercisesPage({super.key});

  @override
  _StretchingExercisesPageState createState() => _StretchingExercisesPageState();
}

class _StretchingExercisesPageState extends State<StretchingExercisesPage> {
  List<Map<String, dynamic>> exercises = []; // List to hold exercises from Firestore
  bool isLoading = true; // Loading state

  // Fetch all exercises
  Future<void> _fetchExercises() async {
    try {
      // Fetching documents from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('stretching_exercises')
          .get();

      print('Query Snapshot: ${querySnapshot.docs.length} documents found.'); // Log number of documents

      // Check if the documents are being fetched correctly
      for (var doc in querySnapshot.docs) {
        print('Document ID: ${doc.id}, Data: ${doc.data()}'); // Log each document's data
      }

      setState(() {
        exercises = querySnapshot.docs
            .map((doc) => doc.data()) // Get exercise data directly
            .toList();
        isLoading = false; // Set loading to false after fetching
      });

      if (exercises.isEmpty) {
        print('No exercises found.');
      }
    } catch (e) {
      print('Error fetching exercises: $e'); // Handle any errors
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExercises(); // Fetch exercises when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stretching Exercises'),
        backgroundColor: const Color(0xFF29282C),
      ),
      backgroundColor: const Color(0xFF29282C),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : exercises.isNotEmpty
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
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'No exercises available.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
    );
  }
}
