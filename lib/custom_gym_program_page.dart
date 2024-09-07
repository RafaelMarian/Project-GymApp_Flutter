import 'package:flutter/material.dart';

class CustomGymProgramPage extends StatefulWidget {
  @override
  _CustomGymProgramPageState createState() => _CustomGymProgramPageState();
}

class _CustomGymProgramPageState extends State<CustomGymProgramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Gym Program'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Text('Custom Gym Program Page Content'),
      ),
    );
  }
}
