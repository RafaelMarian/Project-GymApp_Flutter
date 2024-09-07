import 'package:flutter/material.dart';

class CustomCyclingProgramPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Cycling Program'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Text(
          'Create your custom cycling program here!',
          style: TextStyle(fontSize: 18, color: Colors.yellow),
        ),
      ),
    );
  }
}
