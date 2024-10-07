import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cards_id.dart';
import 'case_opening_animation.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<CardItem> cards = [];
  int _totalCases = 0; // Variable to hold total cases
  int _totalPoints = 0; // Variable to hold total points

  @override
  void initState() {
    super.initState();
    _loadCardsFromFirestore(); // Fetch cards from Firestore when the page loads
    _fetchTotalCases(); // Fetch total cases from Firestore
    _fetchTotalPoints(); // Fetch total points from Firestore
  }

  Future<void> _loadCardsFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await firestore.collection('inventory').get();
      List<CardItem> loadedCards = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CardItem(
          name: data['name'],
          rarity: Rarity.values.firstWhere((e) => e.toString() == data['rarity']),
        );
      }).toList();

      setState(() {
        cards = loadedCards; // Update the inventory with the loaded cards
      });
    } catch (e) {
      print("Error loading cards from Firestore: $e");
    }
  }

  Future<void> _fetchTotalCases() async {
    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');

    try {
      final snapshot = await totalDoc.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          _totalCases = data['totalCases'] ?? 0; // Load total cases from Firebase
        });
      }
    } catch (e) {
      print('Error fetching total cases: $e');
    }
  }

  Future<void> _fetchTotalPoints() async {
    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');

    try {
      final snapshot = await totalDoc.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          _totalPoints = data['totalPoints'] ?? 0; // Load total points from Firebase
        });
      }
    } catch (e) {
      print('Error fetching total points: $e');
    }
  }

  void _showOpenCaseDialog() {
    if (_totalCases <= 0) {
      // Show a dialog indicating no cases available
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No Cases Available'),
            content: const Text('You do not have any cases to open.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the method if no cases are available
    }

    // Check if user has enough points
    if (_totalPoints < 5) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Insufficient Points'),
            content: const Text('You need at least 5 points to open a case.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit if not enough points
    }

    // Proceed with opening the case
    _openCase();
  }

  void _openCase() {
    // Decrease the total case count and points
    setState(() {
      _totalCases -= 1;
      _totalPoints -= 5; // Deduct 5 points
    });

    // Update total points in Firestore
    _updateTotalPointsInFirestore();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaseOpeningAnimation(
          onCardRevealed: (CardItem revealedCard) {
            setState(() {
              cards.add(revealedCard); // Add the revealed card to the inventory
            });

            // Save the card to Firestore
            _saveCardToFirestore(revealedCard);
            _updateTotalCasesInFirestore(); // Update total cases in Firestore
          },
        ),
      ),
    );
  }

  void _saveCardToFirestore(CardItem card) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('inventory').add({
        'name': card.name,
        'rarity': card.rarity.toString(),
      });
    } catch (e) {
      print("Error saving card to Firestore: $e");
    }
  }

  void _updateTotalCasesInFirestore() async {
    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');

    try {
      await totalDoc.update({'totalCases': _totalCases}); // Update total cases in Firestore
    } catch (e) {
      print('Error updating total cases: $e');
    }
  }

  void _updateTotalPointsInFirestore() async {
    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');

    try {
      await totalDoc.update({'totalPoints': _totalPoints}); // Update total points in Firestore
    } catch (e) {
      print('Error updating total points: $e');
    }
  }

  void _showEarnDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Earn More Cases and Points'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Watch an Ad for 10 Points'),
                onTap: () {
                  Navigator.pop(context);
                  _earnPoints(10); // Add points when ad is "watched"
                },
              ),
              ListTile(
                title: const Text('Watch an Ad for 1 Case'),
                onTap: () {
                  Navigator.pop(context);
                  _earnCases(1); // Add cases when ad is "watched"
                },
              ),
              ListTile(
                title: const Text('Buy 50 Points for \$0.99'),
                onTap: () {
                  Navigator.pop(context);
                  _earnPoints(50); // Add points when user buys them
                },
              ),
              ListTile(
                title: const Text('Buy 5 Cases for \$1.99'),
                onTap: () {
                  Navigator.pop(context);
                  _earnCases(5); // Add cases when user buys them
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _earnPoints(int points) {
    setState(() {
      _totalPoints += points;
    });

    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');
    totalDoc.update({'totalPoints': _totalPoints}); // Update points in Firestore
  }

  void _earnCases(int cases) {
    setState(() {
      _totalCases += cases;
    });

    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');
    totalDoc.update({'totalCases': _totalCases}); // Update cases in Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Container(
        color: const Color.fromARGB(255, 40, 39, 41),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Display Total Points and Total Cases with the new button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Points: $_totalPoints',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'Total Cases: $_totalCases',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: _showEarnDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7BB0E),
                    ),
                    child: const Text('Earn More'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildCardsSection(),
            const Divider(color: Color(0xFFF7BB0E)),
            _buildOpenCaseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsSection() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cards.isEmpty
            ? const Center(
                child: Text(
                  'No cards available',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: cards[index].rarity.color,
                    child: Center(
                      child: Text(
                        cards[index].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildOpenCaseButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _showOpenCaseDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF7BB0E),
        ),
        child: const Text('Open Case'),
      ),
    );
  }
}
