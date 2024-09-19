import 'package:flutter/material.dart';

class HomeWorkoutPage extends StatelessWidget {
  const HomeWorkoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Workout'),
        backgroundColor: const Color(0xFF29282C), // Dark background
      ),
      body: const Center(
        child: Text(
          'Welcome to the Home Workout Program!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF29282C), // Dark background
    );
  }
}
