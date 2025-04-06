import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodSearchPage extends StatefulWidget {
  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> results = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;

  void searchFood(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('food_database')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      results = snapshot.docs;
    });
  }

  Future<void> addFoodToLog(Map<String, dynamic> food) async {
    final today = DateTime.now();
    final dateStr = "${today.year}-${today.month}-${today.day}";
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef
        .collection('nutrition_logs')
        .doc(dateStr)
        .collection('food_entries')
        .add(food);

    final logDoc = userRef.collection('nutrition_logs').doc(dateStr);
    final logSnapshot = await logDoc.get();

    if (!logSnapshot.exists) {
      await logDoc.set({
        'protein': food['protein'],
        'fats': food['fats'],
        'carbs': food['carbs'],
      });
    } else {
      await logDoc.update({
        'protein': FieldValue.increment(food['protein']),
        'fats': FieldValue.increment(food['fats']),
        'carbs': FieldValue.increment(food['carbs']),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Food")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search food",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => searchFood(searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final food = results[index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(food['name']),
                  subtitle: Text(
                      "Protein: ${food['protein']}g, Fats: ${food['fats']}g, Carbs: ${food['carbs']}g"),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      await addFoodToLog(food);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
