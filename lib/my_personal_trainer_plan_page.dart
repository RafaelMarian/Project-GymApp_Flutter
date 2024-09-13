import 'package:flutter/material.dart';

class PersonalTrainerPlanPage extends StatelessWidget {
  const PersonalTrainerPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Personal Trainer Plan'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: const Center(
        child: Text(
          'Personal Trainer Plan Page',
          style: TextStyle(color: Colors.yellow, fontSize: 24),
        ),
      ),
    );
  }
}
