import 'package:flutter/material.dart';
import 'user_profile.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final PageController _pageController = PageController();
  final UserProfile _userProfile = UserProfile();
  bool _hasAnsweredFirstQuestion =
      false; // Track if the first question is answered

  void _onNextPage(String response) {
    // Store the response based on the current page
    int pageIndex = _pageController.page!.toInt();

    switch (pageIndex) {
      case 0:
        _userProfile.name = response;
        break;
      case 1:
        _userProfile.height = response;
        break;
      case 2:
        _userProfile.weight = response;
        break;
      case 3:
        _userProfile.gender = response;
        break;
      case 4:
        _userProfile.gymFrequency = response;
      case 5:
        _userProfile.age = response;
        // Finalize and store profile data
        // e.g., save to Firebase or local storage
        break;
    }

    setState(() {
      if (pageIndex == 0) {
        _hasAnsweredFirstQuestion = true;
      }
    });

    // Move to the next page
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _onPreviousPage() {
    // Move to the previous page
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
        backgroundColor: Colors.grey[800], // AppBar background color
      ),
      backgroundColor: Colors.grey[800], // Background color
      body: PageView(
        controller: _pageController,
        children: [
          _buildQuestionPage('What is your name?', 'Enter your name', _onNextPage,
              _onPreviousPage),
          _buildQuestionPage('What is your height?', 'Enter your height',
              _onNextPage, _onPreviousPage),
          _buildQuestionPage('What is your body weight?',
              'Enter your body weight', _onNextPage, _onPreviousPage),
          _buildQuestionPage('What is your gender?', 'Select your gender',
              _onNextPage, _onPreviousPage),
          _buildQuestionPage('How often do you go to the gym?',
              'Select frequency', _onNextPage, _onPreviousPage),
          _buildQuestionPage('What is your age?', 'Enter your age', _onNextPage,
              _onPreviousPage),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(String question, String hint,
      void Function(String) onNext, void Function() onPrevious) {
    TextEditingController controller = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  question,
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.yellow),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.yellow), // Text color
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Spacer(), // Push buttons to the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_hasAnsweredFirstQuestion) // Show "Previous" button only if the first question is answered
                  ElevatedButton(
                    onPressed: () {
                      onPrevious();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Button background color
                    ),
                    child: Text('Previous'),
                  ),
                SizedBox(width: 20.0), // Space between buttons
                ElevatedButton(
                  onPressed: () {
                    onNext(controller.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // Button background color
                  ),
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
