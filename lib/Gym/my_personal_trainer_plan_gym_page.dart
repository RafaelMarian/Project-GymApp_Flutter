import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_buddies/Create_Yout_Workout_Day.dart';

class MyPersonalTrainerPlanPageGym extends StatefulWidget {
  const MyPersonalTrainerPlanPageGym({super.key});

  @override
  _AllTrainingPlansPageState createState() => _AllTrainingPlansPageState();
}

class _AllTrainingPlansPageState extends State<MyPersonalTrainerPlanPageGym> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> plans = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAllPlans();
  }

  Future<void> _fetchAllPlans() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('training-plans').get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          plans = querySnapshot.docs;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No training plans found in the database.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching plans: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _confirmDeleteTrainingPlan(String planID) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Plan'),
          content: const Text('Are you sure you want to delete this training plan? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _deleteTrainingPlan(planID);
    }
  }

  Future<void> _deleteTrainingPlan(String planID) async {
    try {
      await FirebaseFirestore.instance.collection('training-plans').doc(planID).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Training plan deleted successfully')),
      );
      _fetchAllPlans();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting plan: $e')),
      );
    }
  }

  Future<void> _addToWorkout(Map<String, dynamic> plan) async {
    // Add selected training plan to the workout page
    await FirebaseFirestore.instance.collection('user-workout-programs').add({
      'clientName': plan['clientName'],
      'days': plan['days'],
      'workoutType': plan['workoutType'],
      'difficulty': plan['difficulty'],
      'timestamp': FieldValue.serverTimestamp(),
      'isTrainingPlan': true, // Mark this as a training plan
      'completed': false,  // Default the "completed" field to false
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateYourWorkoutDay(), // Redirect to the workout page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Training Plans'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41), // Set your background color here
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : plans.isNotEmpty
              ? ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final clientName = plan['clientName']?.toString() ?? 'Unknown Client';
                    final difficulty = plan['difficulty']?.toString() ?? 'No Difficulty';
                    final workoutType = plan['workoutType']?.toString() ?? 'No Workout Type';
                    final days = plan['days'] as Map<String, dynamic>? ?? {};

                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clientName,
                              style: const TextStyle(
                                color: Color(0xFFF7BB0E),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Workout Type: $workoutType, Difficulty: $difficulty',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            ...days.keys.map((day) {
                              final exercises = days[day] as List<dynamic>? ?? [];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$day:',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    ...exercises.map((exercise) {
                                      final completed = exercise['completed'] ?? false;  // Handle the "completed" field
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '${exercise['name']}: Reps: ${exercise['reps']}, Weight: ${exercise['weight']}kg, Rest: ${exercise['restTime']}s,',
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => _addToWorkout(plan.data()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF7BB0E),
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('➕ Add to Workout'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => _confirmDeleteTrainingPlan(plan.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Delete Plan'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    errorMessage.isNotEmpty ? errorMessage : 'No training plans available.',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
    );
  }
}
