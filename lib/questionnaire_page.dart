import 'package:flutter/material.dart';
import 'User/user_profile.dart'; // Import UserProfile from the correct file
import 'HomePage/home_page.dart'; // Import HomePage
import 'User/user_profile_service.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final PageController _pageController = PageController();
  late UserProfile _userProfile; // Declare the UserProfile but initialize later
  bool _hasAnsweredFirstQuestion =
      false; // Track if the first question is answered
  final UserProfileService _userProfileService = UserProfileService();

  @override
  void initState() {
    super.initState();
    _initializeUserProfile();
  }

  Future<void> _initializeUserProfile() async {
    String? userId = await _userProfileService.getUserId();
    if (userId != null) {
      setState(() {
        _userProfile = UserProfile(
            id: userId); // Initialize UserProfile with the fetched ID
      });
    } else {
      // Handle the case where the user is not logged in or ID is null
      print("Error: User ID is null.");
    }
  }

  void _onNextPage(String response) {
    if (_pageController.page == null) return; // Safeguard against null page
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
        break;
      case 5:
        _userProfile.age = response;
        // Navigate to HomePage after the last question
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userProfile: _userProfile),
          ),
        );
        return;
    }

    setState(() {
      if (pageIndex == 0) {
        _hasAnsweredFirstQuestion = true;
      }
    });

    // Move to the next page
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _onPreviousPage() {
    // Move to the previous page
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: PageView(
        controller: _pageController,
        children: [
          _buildQuestionPage('What is your name?', 'Enter your name',
              _onNextPage, _onPreviousPage),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  question,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: Colors.yellow),
                    border: const OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.yellow),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_hasAnsweredFirstQuestion)
                  ElevatedButton(
                    onPressed: _onPreviousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    child: const Text('Previous'),
                  ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _onNextPage(controller.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
