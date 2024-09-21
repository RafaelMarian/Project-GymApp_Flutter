import 'package:flutter/material.dart';
import 'cards_id.dart';
import 'case_opening_animation.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Case> cases = [Case(id: '1', requiredPoints: 100, isOpened: false)];
  List<CardItem> cards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Column(
        children: [
          Text('Cases', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          _buildCasesSection(),
          const Divider(),
          Text('Cards', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          _buildCardsSection(),
        ],
      ),
    );
  }

  Widget _buildCasesSection() {
    return Expanded(
      child: cases.isEmpty
          ? const Center(child: Text('No cases available'))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cases.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
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
                  },
                  child: Card(
                    color: cases[index].isOpened ? Colors.grey : Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Case #${cases[index].id}'),
                          Text('Points: ${cases[index].requiredPoints}'),
                          Text(cases[index].isOpened ? 'Opened' : 'Tap to open'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildCardsSection() {
    return Expanded(
      child: cards.isEmpty
          ? const Center(child: Text('No cards available'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
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
    );
  }
}
