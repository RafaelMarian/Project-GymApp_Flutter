import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String activityLevel = 'light';
  String goal = 'maintenance';

  void saveProfileAndCalculate() async {
    final height = double.parse(heightController.text);
    final weight = double.parse(weightController.text);
    final age = int.parse(ageController.text);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    double bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    double multiplier = activityLevel == 'light'
        ? 1.375
        : activityLevel == 'moderate'
            ? 1.55
            : 1.725;
    double tdee = bmr * multiplier;

    if (goal == 'fat_loss') tdee -= 500;
    if (goal == 'muscle_gain') tdee += 300;

    double protein = weight * 2.2;
    double fats = (tdee * 0.25) / 9;
    double carbs = (tdee - (protein * 4 + fats * 9)) / 4;

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'profile': {
        'height': height,
        'weight': weight,
        'age': age,
        'activityLevel': activityLevel,
        'goal': goal,
        'tdee': tdee,
        'protein': protein,
        'fats': fats,
        'carbs': carbs,
      }
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setup Nutrition Goals")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: heightController, decoration: InputDecoration(labelText: "Height (cm)")),
            TextField(controller: weightController, decoration: InputDecoration(labelText: "Weight (kg)")),
            TextField(controller: ageController, decoration: InputDecoration(labelText: "Age")),
            DropdownButtonFormField<String>(
              value: activityLevel,
              items: ['light', 'moderate', 'heavy']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => activityLevel = val!),
              decoration: InputDecoration(labelText: "Activity Level"),
            ),
            DropdownButtonFormField<String>(
              value: goal,
              items: ['maintenance', 'fat_loss', 'muscle_gain']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => goal = val!),
              decoration: InputDecoration(labelText: "Goal"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfileAndCalculate,
              child: Text("Save & Calculate"),
            )
          ],
        ),
      ),
    );
  }
}
