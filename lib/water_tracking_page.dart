import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class WaterTrackingPage extends StatefulWidget {
  @override
  _WaterTrackingPageState createState() => _WaterTrackingPageState();
}

class _WaterTrackingPageState extends State<WaterTrackingPage> with TickerProviderStateMixin {
  final TextEditingController _waterController = TextEditingController();
  int _currentIntake = 0;
  int _goal = 2000; // Default goal in ml
  double _progress = 0;
  List<Map<String, dynamic>> _waterHistory = []; // To store history data

  late AnimationController firstController;
  late Animation<double> firstAnimation;

  late AnimationController secondController;
  late Animation<double> secondAnimation;

  late AnimationController thirdController;
  late Animation<double> thirdAnimation;

  late AnimationController fourthController;
  late Animation<double> fourthAnimation;

  @override
  void initState() {
    super.initState();
    _fetchData();

    // Initialize water animation controllers
    firstController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    firstAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    secondAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });

    thirdController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    thirdAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });

    fourthController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    fourthAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });

    Timer(Duration(seconds: 2), () {
      firstController.forward();
    });

    Timer(Duration(milliseconds: 1600), () {
      secondController.forward();
    });

    Timer(Duration(milliseconds: 800), () {
      thirdController.forward();
    });

    fourthController.forward();
  }

  Future<void> _fetchData() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day); // Start of today

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('water_data')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> history = [];
      int dailyIntake = 0; // Variable to store the daily intake

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final intake = data['intake'] as int?;
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        if (intake != null) {
          history.add({
            'date': '${timestamp.year}-${timestamp.month}-${timestamp.day}',
            'intake': intake,
          });
          // Update dailyIntake with the current day's entries
          dailyIntake += intake;
        }
      }
      setState(() {
        _waterHistory = history;
        _currentIntake = dailyIntake; // Set today's intake
        _progress = _currentIntake / _goal; // Update progress
      });
    } catch (e) {
      print('Error fetching water data: $e');
    }
  }

  void _updateWaterIntake() {
    final intake = int.tryParse(_waterController.text) ?? 0;
    if (intake > 0) {
      setState(() {
        _currentIntake += intake;
        if (_currentIntake > _goal) {
          _currentIntake = _goal;
        }
        _progress = _currentIntake / _goal; // Update progress
      });

      FirebaseFirestore.instance.collection('water_data').add({
        'intake': intake,
        'timestamp': Timestamp.now(),
      }).then((_) => _fetchData()); // Refresh data after adding
    }
  }

  Future<void> _clearData() async {
    bool confirmDelete = await _showConfirmationDialog();
    if (confirmDelete) {
      FirebaseFirestore.instance.collection('water_data').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      setState(() {
        _currentIntake = 0;
        _progress = 0;
        _waterHistory.clear(); // Clear the history as well
      });
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion", style: TextStyle(color: Color(0xFFEFE9E1))), // Text color
          content: Text("Are you sure you want to clear all data? This action cannot be undone.", style: TextStyle(color: Color(0xFFEFE9E1))), // Text color
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Color(0xFFD1C7BD))), // Button text color
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Color(0xFFD1C7BD))), // Button text color
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Water Tracking',
          style: TextStyle(color: Color(0xFFEFE9E1)), // Primary text color
        ),
        backgroundColor: const Color(0xFF322D29), // Dark teal
        centerTitle: true, // Center the title
      ),
      backgroundColor: const Color(0xFFD1C7BD), // Lighter beige
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WaterFillAnimation(
              progress: _progress, // Pass progress to the animation widget
              firstAnimation: firstAnimation,
              secondAnimation: secondAnimation,
              thirdAnimation: thirdAnimation,
              fourthAnimation: fourthAnimation,
            ),
            const SizedBox(height: 20),
            Text(
              '$_currentIntake ml',
              style: const TextStyle(fontSize: 36, color: Color(0xFFEFE9E1)), // Primary text color
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _waterController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD9D9D9)), // Light grey border
                ),
                filled: true,
                fillColor: Color(0xFFEFE9E1), // Text field background
                labelText: 'Enter Water Intake (ml)',
                labelStyle: TextStyle(color: Color(0xFF322D29)), // Dark teal label
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<int>(
              value: _goal,
              items: [1000, 2000, 3000, 4000, 5000].map((goal) {
                return DropdownMenuItem<int>(
                  value: goal,
                  child: Text('$goal ml'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _goal = value ?? 2000;
                  _progress = _currentIntake / _goal; // Update progress after changing goal
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateWaterIntake,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF322D29), // Dark teal button
              ),
              child: const Text(
                'Add Water',
                style: TextStyle(color: Color(0xFFEFE9E1)), // Button text color
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _clearData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF322D29), // Dark teal button
              ),
              child: const Text(
                'Clear Data',
                style: TextStyle(color: Color(0xFFEFE9E1)), // Button text color
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Water Intake History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF322D29)), // Dark teal text color
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _waterHistory.length,
                itemBuilder: (context, index) {
                  final entry = _waterHistory[index];
                  return ListTile(
                    title: Text(
                      '${entry['date']}: ${entry['intake']} ml',
                      style: const TextStyle(color: Color(0xFF322D29)), // Dark teal text
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaterFillAnimation extends StatelessWidget {
  final double progress;
  final Animation<double> firstAnimation;
  final Animation<double> secondAnimation;
  final Animation<double> thirdAnimation;
  final Animation<double> fourthAnimation;

  const WaterFillAnimation({
    Key? key,
    required this.progress,
    required this.firstAnimation,
    required this.secondAnimation,
    required this.thirdAnimation,
    required this.fourthAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            height: size.width * 0.5,
            width: size.width * 0.5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      firstAnimation,
                      secondAnimation,
                      thirdAnimation,
                      fourthAnimation,
                    ]),
                    builder: (context, child) {
                      return CustomPaint(
                        painter: WaterFillPainter(
                          progress: progress,
                          firstAnimValue: firstAnimation.value,
                          secondAnimValue: secondAnimation.value,
                          thirdAnimValue: thirdAnimation.value,
                          fourthAnimValue: fourthAnimation.value,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WaterFillPainter extends CustomPainter {
  final double progress;
  final double firstAnimValue;
  final double secondAnimValue;
  final double thirdAnimValue;
  final double fourthAnimValue;

  WaterFillPainter({
    required this.progress,
    required this.firstAnimValue,
    required this.secondAnimValue,
    required this.thirdAnimValue,
    required this.fourthAnimValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint waterPaint = Paint()
      ..color = Colors.blue[400]!
      ..style = PaintingStyle.fill;

    // Draw the water fill according to the progress
    double waterHeight = size.height * (1 - progress);
    Rect waterRect = Rect.fromLTRB(0, waterHeight, size.width, size.height);
    canvas.drawRect(waterRect, waterPaint);

    // Add some wave effects using the animated values
    Path wavePath = Path();
    wavePath.moveTo(0, waterHeight);
    wavePath.cubicTo(
      size.width * 0.25,
      waterHeight + 10 * firstAnimValue,
      size.width * 0.75,
      waterHeight - 10 * secondAnimValue,
      size.width,
      waterHeight,
    );
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, waterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
