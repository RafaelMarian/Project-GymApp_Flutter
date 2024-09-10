import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTrainingPlanPageGym extends StatefulWidget {
  @override
  _CreateTrainingPlanPageState createState() => _CreateTrainingPlanPageState();
}

class _CreateTrainingPlanPageState extends State<CreateTrainingPlanPageGym> {
  String? clientID;
  String? difficulty;
  String? workoutType;
  String? gender;
  Map<String, dynamic> days = {}; // Use this to build the daily plan

  Future<void> _submitPlan() async {
    try {
      await FirebaseFirestore.instance.collection('training-plans').add({
        'trainerID': 'current_trainer_id', // Replace with actual trainer ID
        'clientID': clientID,
        'difficulty': difficulty,
        'workoutType': workoutType,
        'gender': gender,
        'days': days,
      });
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Plan submitted successfully')));
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting plan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Training Plan'),
      ),
      body: Column(
        children: [
          // Input fields for creating the plan
          TextField(
            onChanged: (value) => clientID = value,
            decoration: InputDecoration(labelText: 'Client ID'),
          ),
          // Additional fields for difficulty, workoutType, gender, and days
          ElevatedButton(
            onPressed: _submitPlan,
            child: Text('Submit Plan'),
          ),
        ],
      ),
    );
  }
}
