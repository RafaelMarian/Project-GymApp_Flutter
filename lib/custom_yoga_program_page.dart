import 'package:flutter/material.dart';

class CustomYogaProgramPage extends StatefulWidget {
  const CustomYogaProgramPage({super.key});

  @override
  _CustomYogaProgramPageState createState() => _CustomYogaProgramPageState();
}

class _CustomYogaProgramPageState extends State<CustomYogaProgramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Yoga Program'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Your Custom Yoga Program',
              style: TextStyle(fontSize: 18, color: Color(0xFFF7BB0E)),
            ),
            SizedBox(height: 20),
            Text(
              'Add yoga exercises and set the number of reps, duration, etc.',
              style: TextStyle(fontSize: 16, color: Color(0xFFF7BB0E)),
            ),
            // You can add form fields, dropdowns, etc. here for customization.
          ],
        ),
      ),
    );
  }
}
