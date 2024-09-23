import 'dart:math';
import 'cards_id.dart';

class CaseOpeningLogic {
  static final List<CardItem> allPossibleCards = [
    CardItem(name: 'Common Card 1', rarity: Rarity.common),
    CardItem(name: 'Rare Card 1', rarity: Rarity.rare),
    CardItem(name: 'Epic Card 1', rarity: Rarity.epic),
    CardItem(name: 'Legendary Card 1', rarity: Rarity.legendary),
    CardItem(name: 'Mythical Card 1', rarity: Rarity.mythical),
  ];

  static CardItem openCase() {
    double randomValue = Random().nextDouble();
    List<CardItem> selectedCards;

    if (randomValue < 0.6) {
      selectedCards = allPossibleCards
          .where((card) => card.rarity == Rarity.common)
          .toList();
    } else if (randomValue < 0.85) {
      selectedCards =
          allPossibleCards.where((card) => card.rarity == Rarity.rare).toList();
    } else if (randomValue < 0.95) {
      selectedCards =
          allPossibleCards.where((card) => card.rarity == Rarity.epic).toList();
    } else if (randomValue < 0.99) {
      selectedCards = allPossibleCards
          .where((card) => card.rarity == Rarity.legendary)
          .toList();
    } else {
      selectedCards = allPossibleCards
          .where((card) => card.rarity == Rarity.mythical)
          .toList();
    }

    if (selectedCards.isNotEmpty) {
      return selectedCards[Random().nextInt(selectedCards.length)];
    } else {
      throw Exception("No cards available of the selected rarity.");
    }
  }
}
