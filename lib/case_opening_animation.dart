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
  int? _revealedCardIndex;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _pageController = PageController(initialPage: 50, viewportFraction: 0.3);

    _scrollingCards = List.generate(100, (_) => CaseOpeningLogic.openCase());

    Future.delayed(const Duration(milliseconds: 100), () {
      _startCaseOpening();
    });
  }

  void _startCaseOpening() {
    _controller.forward().then((_) {
      if (_scrollingCards.isNotEmpty) {
        int currentPageIndex = _pageController.page?.round() ?? 50;
        currentPageIndex = currentPageIndex.clamp(0, _scrollingCards.length - 1);

        _revealedCard = _scrollingCards[currentPageIndex];
        _revealedCardIndex = currentPageIndex; // Store the index of the revealed card

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

        _pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
      backgroundColor: Color.fromARGB(255, 40, 39, 41), // Change background color here
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

                // Highlight only the revealed card based on the index
                double scale = (_animationCompleted && _revealedCardIndex == index) ? 1.2 : 1.0;

                return Center(
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 150,
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      color: _scrollingCards[index].rarity.color,
                      child: Center(
                        child: Text(
                          _scrollingCards[index].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
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
    _pageController.dispose();
    super.dispose();
  }
}
