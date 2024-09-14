// lib/nutrition_page.dart

import 'package:flutter/material.dart';

class NutritionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Text('Nutrition Information Here'),
      ),
    );
  }
}
