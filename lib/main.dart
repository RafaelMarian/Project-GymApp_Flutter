import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart'; // Import your login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Buddies',
      theme: ThemeData(
        // Remove the ColorScheme.fromSeed to prevent automatic color generation
        colorScheme: const ColorScheme.dark(
          primary: Colors.black, // Primary color for app
          onPrimary: Colors.white, // Color for text/icons on primary background
          surface: Colors.black, // Background color for surfaces like cards
          onSurface: Colors.white, // Text color on surface backgrounds
        ),
        useMaterial3: true,

        // Input decoration for TextFields across the app
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey, // Background color of the TextField
          labelStyle: TextStyle(color: Colors.white), // Label color
          hintStyle: TextStyle(color: Colors.white), // Hint text color
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Border when not focused
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Border when focused
          ),
        ),

        // Ensure all text input uses white text by default
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Default text style for input text
        ),
        
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white, // Cursor color
          selectionColor: Colors.tealAccent, // Highlight color for selected text
          selectionHandleColor: Colors.teal, // Handle color for text selection
        ),
      ),
      home: const SplashScreen(), // Set SplashScreen as the initial screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to LoginPage after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginPage()), // Navigate to LoginPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'), // Display the logo
      ),
    );
  }
}
