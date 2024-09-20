import 'package:flutter/material.dart';
import 'case_opening_logic.dart';
import 'cards_id.dart';

class CaseOpeningAnimation extends StatefulWidget {
  final Function(CardItem) onCardRevealed;

  CaseOpeningAnimation({required this.onCardRevealed});

  @override
  _CaseOpeningAnimationState createState() => _CaseOpeningAnimationState();
}

class _CaseOpeningAnimationState extends State<CaseOpeningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PageController _pageController;
  List<CardItem> _scrollingCards = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _pageController = PageController();

    // Generate random cards to simulate the case-opening animation
    _scrollingCards = List.generate(100, (_) => CaseOpeningLogic.openCase());

    // Start the animation with a slight delay to ensure the PageView is built
    Future.delayed(Duration(milliseconds: 100), () {
      _startCaseOpening();
    });
  }

  void _startCaseOpening() {
    // Start the animation
    _controller.forward().then((_) {
      if (_scrollingCards.isNotEmpty) {
        // Ensure the page index is within bounds
        int currentPageIndex = _pageController.page?.round() ?? 0;
        currentPageIndex = currentPageIndex.clamp(0, _scrollingCards.length - 1);

        // Get the revealed card from the clamped index
        CardItem revealedCard = _scrollingCards[currentPageIndex];

        // Call the callback with the revealed card
        widget.onCardRevealed(revealedCard);
      }
    });

    // Animate the scrolling effect
    _controller.addListener(() {
      if (_controller.isAnimating) {
        int pageIndex = (_controller.value * (_scrollingCards.length - 1)).toInt();
        pageIndex = pageIndex.clamp(0, _scrollingCards.length - 1);
        print("Animating to page index: $pageIndex"); // Log the page index

        // Animate to the calculated page index
        _pageController.animateToPage(
          pageIndex,
          duration: Duration(milliseconds: 50),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _scrollingCards.isNotEmpty ? _scrollingCards.length : 1,
        itemBuilder: (context, index) {
          if (_scrollingCards.isEmpty) {
            return Center(child: Text("No cards available"));
          }
          return Center(
            child: Container(
              width: 100,
              height: 150,
              color: _scrollingCards[index].rarity.color,
              child: Center(
                child: Text(
                  _scrollingCards[index].name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
