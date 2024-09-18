import 'package:flutter/material.dart';

class MyPersonalTrainerPlanYogaPage extends StatefulWidget {
  const MyPersonalTrainerPlanYogaPage({super.key});

  @override
  _MyPersonalTrainerPlanYogaPageState createState() =>
      _MyPersonalTrainerPlanYogaPageState();
}

class _MyPersonalTrainerPlanYogaPageState
    extends State<MyPersonalTrainerPlanYogaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Personal Trainer Plan (Yoga)'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personalized Yoga Plan',
              style: TextStyle(fontSize: 24, color: Colors.yellow),
            ),
            const SizedBox(height: 20),
            const Text(
              'Here is your personalized yoga routine to help you with flexibility and mindfulness.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildWorkoutItem('Morning Flow', '10 mins of Sun Salutations'),
                  _buildWorkoutItem('Core Strengthening', '15 mins of Boat Pose'),
                  _buildWorkoutItem('Relaxation', '5 mins of Child\'s Pose'),
                  // Add more yoga exercises
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
      color: Color.fromARGB(255, 40, 39, 41),
      child: ListTile(
        title: Text(
          workoutName,
          style: const TextStyle(color: Color(0xFFF7BB0E), fontSize: 18),
        ),
        subtitle: Text(
          details,
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
        ),
      ),
    );
  }
}
