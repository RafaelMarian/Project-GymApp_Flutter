import 'package:flutter/material.dart';

class PersonalTrainerPlanPage extends StatelessWidget {
  const PersonalTrainerPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Personal Trainer Plan'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41),
      body: const Center(
        child: Text(
          'Personal Trainer Plan Page',
          style: TextStyle(color: Color(0xFFF7BB0E), fontSize: 24),
        ),
      ),
    );
  }
}
