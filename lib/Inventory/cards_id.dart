import 'package:flutter/material.dart';

class Case {
  final String id;
  final int requiredPoints;
  final bool isOpened;

  Case({
    required this.id,
    required this.requiredPoints,
    this.isOpened = false,
  });
}

class CardItem {
  final String name;
  final Rarity rarity;

  CardItem({
    required this.name,
    required this.rarity,
  });
}

enum Rarity { common, rare, epic, legendary, mythical }

extension RarityColor on Rarity {
  Color get color {
    switch (this) {
      case Rarity.common:
        return Colors.grey;
      case Rarity.rare:
        return Colors.green;
      case Rarity.epic:
        return Colors.blue;
      case Rarity.legendary:
        return Colors.purple;
      case Rarity.mythical:
        return Colors.yellow;
    }
  }
}
