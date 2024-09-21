import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Container(
        color: const Color.fromARGB(255, 40, 39, 41), // Background color change
        child: Column(
          children: [
            const SizedBox(height: 20), // Padding from the top
            _buildCardsSection(), // Cards displayed first (above)
            const Divider(color: Color(0xFFF7BB0E)), // Divider between sections
            _buildCasesSection(), // Cases displayed below
          ],
        ),
      ),
    );
  }

  Widget _buildCardsSection() {
    return Expanded(
      flex: 2, // Takes up more space for cards
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
                  crossAxisCount: 4, // Smaller cards with 4 in a row
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2 / 3, // Make the cards taller than wide
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
    flex: 1, // Takes up less space for cases
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: cases.isEmpty
          ? const Center(
              child: Text(
                'No cases available',
                style: TextStyle(color: Colors.white),
              ),
            )
          : SizedBox( // Explicitly set the height for the ListView
              height: 80, // Set the height for the entire section
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cases.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showOpenCaseDialog(index), // Show dialog on tap
                    child: Card(
                      color: cases[index].isOpened ? Colors.grey : const Color(0xFFF7BB0E),
                      child: Container(
                        width: 60, // Smaller square size
                        height: 40, // Set the same height to maintain the square shape
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


  /// Show a confirmation dialog before opening the case
  void _showOpenCaseDialog(int index) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Open Case'),
        content: const Text('Do you want to open this case?'),
        actions: [
          // Cancel Button - Red Color
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // Set text color to red
            ),
            child: const Text('Cancel'),
          ),
          // Open Button - Green Color
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _openCase(index); // Open case if confirmed
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.green, // Set text color to green
            ),
            child: const Text('Open'),
          ),
        ],
      );
    },
  );
}


  /// Navigate to CaseOpeningAnimation page when case is opened
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
            },
          ),
        ),
      );
    }
  }
}
