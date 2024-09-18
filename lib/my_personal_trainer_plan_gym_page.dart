import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    // Show a confirmation dialog
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

    // If confirmed, proceed with deletion
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

      // Re-fetch the plans after deletion to update the list
      _fetchAllPlans();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting plan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Training Plans'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41), // Set your background color here
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : plans.isNotEmpty
              ? ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final planID = plan.id;
                    final clientName = plan['clientName'] ?? 'Unknown Client';
                    final trainerName = plan['trainerName'] ?? 'Unknown Trainer';
                    final muscleGroup = plan['muscleGroup'] ?? 'Unknown Muscle Group';
                    final difficulty = plan['difficulty'] ?? 'No Difficulty';
                    final workoutType = plan['workoutType'] ?? 'No Workout Type';
                    final days = plan['days'] as Map<String, dynamic>? ?? {};

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        title: Text(
                          '$muscleGroup by $trainerName for $clientName',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Workout Type: $workoutType, Difficulty: $difficulty'),
                        children: [
                          ...days.keys.map((day) {
                            final exercises = days[day] as List<dynamic>? ?? [];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '$day:',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ...exercises.map((exercise) {
                                  return ListTile(
                                    title: Text(exercise['name'] ?? 'Unnamed Exercise'),
                                    subtitle: Text(
                                      'Reps: ${exercise['reps']}, Weight: ${exercise['weight']}kg, Rest: ${exercise['restTime']}s',
                                    ),
                                  );
                                }),
                              ],
                            );
                          }),
                          ElevatedButton(
                            onPressed: () => _confirmDeleteTrainingPlan(planID),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Delete Plan'),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    errorMessage.isNotEmpty
                        ? errorMessage
                        : 'No training plans available.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
    );
  }
}
