import 'package:flutter/material.dart';
import 'user_profile.dart'; // Import UserProfile from the correct file
import 'home_page.dart'; // Import HomePage
import 'user_profile_service.dart';
import 'setup_page.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final PageController _pageController = PageController();
  late UserProfile _userProfile; // Declare the UserProfile but initialize later
  bool _hasAnsweredFirstQuestion =
      false; // Track if the first question is answered
  final UserProfileService _userProfileService = UserProfileService();
  bool _notifyInApp = false;
  bool _notifyEmail = false;

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
        _userProfile.dateOfBirth = response;
        break;
      case 5:
        _userProfile.gymFrequency = response;
        break;
      case 6:
        _userProfile.goals = response;
        break;
      case 7:
        _userProfile.notifyInApp = _notifyInApp;
        _userProfile.notifyEmail = _notifyEmail;
        // Navigate to SetupPage after the last question
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SetupPage(userProfile: _userProfile)),
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
    if (_userProfile == null) {
      // Show a loading screen or handle uninitialized UserProfile
      return Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
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
          _buildQuestionPage('What is your date of birth?',
              'Enter your date of birth', _onNextPage, _onPreviousPage),
          _buildQuestionPage('How often do you go to the gym?',
              'Select frequency', _onNextPage, _onPreviousPage),
          _buildQuestionPage('What are your goals?', 'Enter your goals',
              _onNextPage, _onPreviousPage),
          _buildNotificationPage(_onNextPage, _onPreviousPage),
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
                    color: Colors.yellow,
                  ),
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
                  style: TextStyle(color: Colors.yellow),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Spacer(),
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
                    child: Text('Previous'),
                  ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _onNextPage(controller.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
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

  Widget _buildNotificationPage(
      void Function(String) onNext, void Function() onPrevious) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Do you agree to receive notifications from the app?',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              Checkbox(
                value: _notifyInApp,
                onChanged: (value) {
                  setState(() {
                    _notifyInApp = value ?? false;
                  });
                },
              ),
              Text('In-App Notifications'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _notifyEmail,
                onChanged: (value) {
                  setState(() {
                    _notifyEmail = value ?? false;
                  });
                },
              ),
              Text('Email Notifications'),
            ],
          ),
          SizedBox(height: 20.0),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _onPreviousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child: Text('Previous'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _onNextPage(
                        ''); // Passing empty response for notifications page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
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
