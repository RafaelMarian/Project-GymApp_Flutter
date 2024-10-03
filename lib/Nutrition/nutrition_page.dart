import 'package:flutter/material.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        backgroundColor: const Color(0xFF29282C), // Dark background
      ),
      body: const Center(
        child: Text(
          'Welcome to Nutrition Page!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF29282C), // Dark background
    );
  }
}
