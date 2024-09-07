import 'package:flutter/material.dart';

class CustomYogaProgramPage extends StatefulWidget {
  @override
  _CustomYogaProgramPageState createState() => _CustomYogaProgramPageState();
}

class _CustomYogaProgramPageState extends State<CustomYogaProgramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Yoga Program'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Your Custom Yoga Program',
              style: TextStyle(fontSize: 18, color: Colors.yellow),
            ),
            SizedBox(height: 20),
            Text(
              'Add yoga exercises and set the number of reps, duration, etc.',
              style: TextStyle(fontSize: 16, color: Colors.yellow),
            ),
            // You can add form fields, dropdowns, etc. here for customization.
          ],
        ),
      ),
    );
  }
}
