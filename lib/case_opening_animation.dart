import 'package:flutter/material.dart';
import 'case_opening_logic.dart';
import 'cards_id.dart';

class CaseOpeningAnimation extends StatefulWidget {
  final Function(CardItem) onCardRevealed;

  const CaseOpeningAnimation({super.key, required this.onCardRevealed});

  @override
  _CaseOpeningAnimationState createState() => _CaseOpeningAnimationState();
}

class _CaseOpeningAnimationState extends State<CaseOpeningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PageController _pageController;
  List<CardItem> _scrollingCards = [];
  bool _animationCompleted = false;
  CardItem? _revealedCard;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _pageController = PageController();

    _scrollingCards = List.generate(100, (_) => CaseOpeningLogic.openCase());

    Future.delayed(const Duration(milliseconds: 100), () {
      _startCaseOpening();
    });
  }

  void _startCaseOpening() {
    _controller.forward().then((_) {
      if (_scrollingCards.isNotEmpty) {
        int currentPageIndex = _pageController.page?.round() ?? 0;
        currentPageIndex = currentPageIndex.clamp(0, _scrollingCards.length - 1);

        _revealedCard = _scrollingCards[currentPageIndex];

        setState(() {
          _animationCompleted = true;
        });

        widget.onCardRevealed(_revealedCard!);
      }
    });

    _controller.addListener(() {
      if (_controller.isAnimating) {
        double progress = _controller.value;
        double slowDownFactor = _calculateSlowdown(progress);

        int pageIndex = (slowDownFactor * (_scrollingCards.length - 1)).toInt();
        pageIndex = pageIndex.clamp(0, _scrollingCards.length - 1);
        _pageController.jumpToPage(pageIndex);
      }
    });
  }

  double _calculateSlowdown(double progress) {
    if (progress < 0.7) {
      return Curves.easeOut.transform(progress);
    } else {
      double remainingProgress = (progress - 0.7) / 0.3;
      return Curves.easeInOutCubic.transform(0.7 + (0.3 * remainingProgress));
    }
  }

  void _takeCard() {
    if (_revealedCard != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _scrollingCards.isNotEmpty ? _scrollingCards.length : 1,
              itemBuilder: (context, index) {
                if (_scrollingCards.isEmpty) {
                  return const Center(child: Text("No cards available"));
                }
                return Center(
                  child: Container(
                    width: 100,
                    height: 150,
                    color: _scrollingCards[index].rarity.color,
                    child: Center(
                      child: Text(
                        _scrollingCards[index].name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_animationCompleted)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _takeCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Take it"),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
