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
      duration: const Duration(seconds: 6),  // Longer duration for suspenseful effect
    );
    _pageController = PageController();

    // Generate random cards to simulate the case-opening animation
    _scrollingCards = List.generate(100, (_) => CaseOpeningLogic.openCase());

    // Start the animation with a slight delay to ensure the PageView is built
    Future.delayed(const Duration(milliseconds: 100), () {
      _startCaseOpening();
    });
  }

  void _startCaseOpening() {
    _controller.forward().then((_) {
      if (_scrollingCards.isNotEmpty) {
        // Ensure the page index is within bounds
        int currentPageIndex = _pageController.page?.round() ?? 0;
        currentPageIndex = currentPageIndex.clamp(0, _scrollingCards.length - 1);

        // Get the revealed card from the clamped index
        _revealedCard = _scrollingCards[currentPageIndex];
        
        // Animation is completed, show the "Take it" button
        setState(() {
          _animationCompleted = true;
        });

        // Call the callback with the revealed card
        widget.onCardRevealed(_revealedCard!);
      }
    });

    // Animate the scrolling effect with a slowdown towards the end
    _controller.addListener(() {
      if (_controller.isAnimating) {
        double progress = _controller.value;

        // Start fast, then gradually slow down towards the end
        double slowDownFactor = _calculateSlowdown(progress);

        int pageIndex = (slowDownFactor * (_scrollingCards.length - 1)).toInt();
        pageIndex = pageIndex.clamp(0, _scrollingCards.length - 1);
        print("Animating to page index: $pageIndex");

        // Animate to the calculated page index
        _pageController.jumpToPage(pageIndex);
      }
    });
  }

  /// A custom function that controls the speed of the animation
  /// Starts fast and slows down exponentially as it approaches the end
  double _calculateSlowdown(double progress) {
    if (progress < 0.7) {
      // First 70% of the animation is fast (linear or near-linear)
      return Curves.easeOut.transform(progress);
    } else {
      // Final 30% slows down dramatically
      double remainingProgress = (progress - 0.7) / 0.3; // normalize to 0..1
      return Curves.easeInOutCubic.transform(0.7 + (0.3 * remainingProgress)); // Slower exponential decay
    }
  }

  void _takeCard() {
    // Handle taking the card and navigating back
    if (_revealedCard != null) {
      widget.onCardRevealed(_revealedCard!);
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
                  backgroundColor: Colors.yellow, // Yellow button color
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
