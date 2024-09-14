// lib/nutrition_page.dart

import 'package:flutter/material.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        backgroundColor: Colors.grey[800],
      ),
      body: const Center(
        child: Text('Nutrition Information Here'),
      ),
    );
  }
}
