import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bodyFatController = TextEditingController();
  final TextEditingController _goalWeightController = TextEditingController();
  String _selectedGoal = "Lose Fat";
  Map<String, double> _nutritionPlan = {};

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  void _calculateNutrition() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double bodyFat = double.tryParse(_bodyFatController.text) ?? 0;
    double goalWeight = double.tryParse(_goalWeightController.text) ?? 0;

    if (weight == 0 || goalWeight == 0) return;

    double leanMass = weight * (1 - bodyFat / 100);
    double protein = leanMass * 2.2;
    double fats = weight * 0.8;
    double carbs = (_selectedGoal == "Lose Fat") ? 100 : 200;
    double calories = (protein * 4) + (fats * 9) + (carbs * 4);

    setState(() {
      _nutritionPlan = {
        "Calories": calories,
        "Protein": protein,
        "Fats": fats,
        "Carbs": carbs,
      };
    });

    _saveToFirebase(calories, protein, fats, carbs);
  }

  Future<void> _saveToFirebase(
      double calories, double protein, double fats, double carbs) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('nutrition_goals')
          .doc(user.uid)
          .set({
        'goal': _selectedGoal,
        'weight': _weightController.text,
        'bodyFat': _bodyFatController.text,
        'goalWeight': _goalWeightController.text,
        'calories': calories,
        'protein': protein,
        'fats': fats,
        'carbs': carbs,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nutrition Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _weightController,
                    decoration:
                        const InputDecoration(labelText: "Current Weight (kg)"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _bodyFatController,
                    decoration:
                        const InputDecoration(labelText: "Body Fat (%)"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _goalWeightController,
                    decoration:
                        const InputDecoration(labelText: "Target Weight (kg)"),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField(
                    value: _selectedGoal,
                    items: ["Lose Fat", "Maintain", "Gain Muscle"]
                        .map((String goal) {
                      return DropdownMenuItem(value: goal, child: Text(goal));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedGoal = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculateNutrition,
                    child: const Text("Calculate"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _nutritionPlan.isNotEmpty
                ? Expanded(
                    child: Column(
                      children: [
                        Text(
                            "Calories: ${_nutritionPlan["Calories"]?.toStringAsFixed(2)} kcal"),
                        Text(
                            "Protein: ${_nutritionPlan["Protein"]?.toStringAsFixed(2)} g"),
                        Text(
                            "Fats: ${_nutritionPlan["Fats"]?.toStringAsFixed(2)} g"),
                        Text(
                            "Carbs: ${_nutritionPlan["Carbs"]?.toStringAsFixed(2)} g"),
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: _nutritionPlan["Protein"] ?? 1.0,
                                  title: "Protein",
                                  color: Colors.blue,
                                ),
                                PieChartSectionData(
                                  value: _nutritionPlan["Fats"] ?? 1.0,
                                  title: "Fats",
                                  color: Colors.red,
                                ),
                                PieChartSectionData(
                                  value: _nutritionPlan["Carbs"] ?? 1.0,
                                  title: "Carbs",
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
