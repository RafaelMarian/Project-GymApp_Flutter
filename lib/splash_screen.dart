import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_buddies/login_page.dart'; // Update with your actual path

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the login page after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your splash screen background color
      body: Center(
        child:
            Image.asset('assets/logo.png'), // Update with your logo asset path
      ),
    );
  }
}
