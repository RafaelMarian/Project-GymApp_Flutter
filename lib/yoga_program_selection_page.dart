import 'package:flutter/material.dart';
import 'custom_yoga_program_page.dart';
import 'planned_yoga_programs_page.dart';

class YogaProgramSelectionPage extends StatefulWidget {
  @override
  _YogaProgramSelectionPageState createState() =>
      _YogaProgramSelectionPageState();
}

class _YogaProgramSelectionPageState
    extends State<YogaProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoga Program Selection'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add your logo here
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Image.asset(
              'assets/yoga_logo.png', // Replace with your logo asset path
              height: 100.0, // Adjust the height as needed
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomYogaProgramPage(),
                      ),
                    );
                  },
                  child: Text('Custom'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
                SizedBox(width: 20), // Space between buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlannedYogaProgramsPage(),
                      ),
                    );
                  },
                  child: Text('Planned Yoga Programs'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
