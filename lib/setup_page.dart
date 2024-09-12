import 'package:flutter/material.dart';
import 'home_page.dart'; // Import HomePage
import 'user_profile.dart';

class SetupPage extends StatelessWidget {
  final UserProfile userProfile;

  const SetupPage({Key? key, required this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulate account setup with a delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userProfile: userProfile)),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Up Your Account'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
            SizedBox(height: 20.0),
            Text(
              'We are setting up your account. This may take a few moments...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.yellow,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
