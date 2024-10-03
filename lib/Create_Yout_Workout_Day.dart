import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateYourWorkoutDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Workout Day'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user-workout-programs').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final exercises = snapshot.data!.docs;

          return exercises.isEmpty
              ? const Center(
                  child: Text(
                    'No exercises added',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (exercise['image'] != null)
                                Center(
                                  child: SizedBox(
                                    height: 200,
                                    child: Image.asset(
                                      'assets/${exercise['name'].toLowerCase().replaceAll(' ', '_')}.png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Text('No Image', style: TextStyle(color: Colors.white)),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              Text(
                                exercise['name'],
                                style: const TextStyle(color: Color(0xFFF7BB0E), fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Reps: ${exercise['reps']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Weight: ${exercise['kg']} kg',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
