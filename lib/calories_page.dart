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
  List<Case> cases = [
    Case(id: '1', requiredPoints: 100, isOpened: false),
    Case(id: '2', requiredPoints: 150, isOpened: false),
    Case(id: '3', requiredPoints: 150, isOpened: false),
    Case(id: '4', requiredPoints: 150, isOpened: false),
    Case(id: '5', requiredPoints: 150, isOpened: false),
    Case(id: '6', requiredPoints: 150, isOpened: false),
    Case(id: '7', requiredPoints: 150, isOpened: false),
    Case(id: '8', requiredPoints: 150, isOpened: false),
    Case(id: '9', requiredPoints: 150, isOpened: false),
  ];

  List<CardItem> cards = [];
  int _totalPoints = 0; // Variable to hold total points

  @override
  void initState() {
    super.initState();
    _loadCardsFromFirestore(); // Fetch cards from Firestore when the page loads
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Container(
        color: const Color.fromARGB(255, 40, 39, 41),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Display Total Points
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Total Points: $_totalPoints',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            _buildCardsSection(),
            const Divider(color: Color(0xFFF7BB0E)),
            _buildCasesSection(),
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

  Widget _buildCasesSection() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cases.isEmpty
            ? const Center(
                child: Text(
                  'No cases available',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cases.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showOpenCaseDialog(index),
                      child: Card(
                        color: cases[index].isOpened ? Colors.grey : const Color(0xFFF7BB0E),
                        child: Container(
                          width: 60,
                          height: 40,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Case #${cases[index].id}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Points: ${cases[index].requiredPoints}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                cases[index].isOpened ? 'Opened' : 'Tap to open',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  void _showOpenCaseDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Open Case'),
          content: const Text('Do you want to open this case?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openCase(index);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Open'),
            ),
          ],
        );
      },
    );
  }

  void _openCase(int index) {
    if (!cases[index].isOpened) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CaseOpeningAnimation(
            onCardRevealed: (CardItem revealedCard) {
              setState(() {
                cases[index] = Case(
                  id: cases[index].id,
                  requiredPoints: cases[index].requiredPoints,
                  isOpened: true,
                );
                cards.add(revealedCard);
              });

              // Save the card to Firestore
              _saveCardToFirestore(revealedCard);
            },
          ),
        ),
      );
    }
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
}
