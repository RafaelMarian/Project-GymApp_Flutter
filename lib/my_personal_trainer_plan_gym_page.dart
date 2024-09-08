import 'package:flutter/material.dart';

class MyPersonalTrainerPlanGymPage extends StatefulWidget {
  @override
  _MyPersonalTrainerPlanGymPageState createState() =>
      _MyPersonalTrainerPlanGymPageState();
}

class _MyPersonalTrainerPlanGymPageState
    extends State<MyPersonalTrainerPlanGymPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Personal Trainer Plan (Gym)'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personalized Gym Plan',
              style: TextStyle(fontSize: 24, color: Colors.yellow),
            ),
            SizedBox(height: 20),
            Text(
              'Here is your personalized gym workout plan tailored to meet your fitness goals.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 30),
            // Add sections or workouts below as needed
            Expanded(
              child: ListView(
                children: [
                  _buildWorkoutItem('Chest & Triceps', '4 Sets of Bench Press'),
                  _buildWorkoutItem('Back & Biceps', '3 Sets of Deadlifts'),
                  _buildWorkoutItem('Leg Day', '4 Sets of Squats'),
                  // Add more workouts as per the plan
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(String workoutName, String details) {
    return Card(
      color: Colors.grey[700],
      child: ListTile(
        title: Text(
          workoutName,
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        subtitle: Text(
          details,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
