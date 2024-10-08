import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_buddies/Steps/custom_circle_for_steps.dart';
import 'pedometer.dart'; // Import the pedometer service
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion chart package
import 'package:intl/intl.dart'; // For date formatting

class StepsCounterPage extends StatefulWidget {
  const StepsCounterPage({super.key});

  @override
  _StepsCounterPageState createState() => _StepsCounterPageState();
}

class _StepsCounterPageState extends State<StepsCounterPage> with WidgetsBindingObserver {
  final TextEditingController _stepsController = TextEditingController();
  int _stepsToday = 0;
  int _goal = 10000; // Default goal
  double _progress = 0;
  double _caloriesBurned = 0;
  List<Map<String, dynamic>> _stepsHistory = []; // To store history data
  final PedometerService _pedometerService = PedometerService();
  bool _isCounting = false;

  // Declare tooltip behavior for the chart
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer
    _fetchData();
    _loadIsCountingState(); // Load the counting state
  }

  // Load counting state from SharedPreferences
  Future<void> _loadIsCountingState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isCounting = prefs.getBool('isCounting') ?? false; // Default to false
    if (_isCounting) {
      _startCountingSteps(); // Resume counting if it was active
    }
  }

  // Ensure counting is managed properly on app lifecycle events
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopCountingSteps();
    } else if (state == AppLifecycleState.resumed) {
      _loadIsCountingState(); // Load state when resumed
    }
  }

  @override
  void dispose() {
    _stopCountingSteps(); // Ensure counting stops when disposed
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  Future<void> _fetchData() async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 7));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('steps_data')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> history = [];
      int latestSteps = 0; // Variable to store the most recent steps data

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final steps = data['steps'] as int?;
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        if (steps != null) {
          history.add({
            'date': '${timestamp.year}-${timestamp.month}-${timestamp.day}',
            'steps': steps,
          });
          latestSteps = steps;
        }
      }
      setState(() {
        _stepsHistory = history;
        _stepsToday = latestSteps; // Set the latest steps as today's steps
        _progress = _stepsToday / _goal;
        _caloriesBurned = _stepsToday * 0.04; // Example calculation: 0.04 calories per step
      });
    } catch (e) {
      print('Error fetching steps data: $e');
    }
  }

  // Handle starting and stopping pedometer counting
  void _startCountingSteps() async {
    if (!_isCounting) {
      setState(() {
        _isCounting = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isCounting', true); // Save state to SharedPreferences

      _pedometerService.startListeningToSteps((newStepCount) {
        setState(() {
          _stepsToday = newStepCount;
          _progress = _stepsToday / _goal;
          _caloriesBurned = _stepsToday * 0.04; // Calories calculation
        });

        // Save steps to Firestore
        FirebaseFirestore.instance.collection('steps_data').add({
          'steps': _stepsToday,
          'timestamp': Timestamp.now(),
        });
      });
    }
  }

  void _stopCountingSteps() async {
    if (_isCounting) {
      setState(() {
        _isCounting = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isCounting', false); // Save state to SharedPreferences

      _pedometerService.stopListeningToSteps();
    }
  }

  // Manually add steps from the input block
  void _addStepsFromInput() {
    final steps = int.tryParse(_stepsController.text) ?? 0;
    setState(() {
      _stepsToday += steps;
      _progress = _stepsToday / _goal;
      _caloriesBurned = _stepsToday * 0.04;
    });

    FirebaseFirestore.instance.collection('steps_data').add({
      'steps': _stepsToday,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> _clearData() async {
    bool confirmDelete = await _showConfirmationDialog();
    if (confirmDelete) {
      FirebaseFirestore.instance.collection('steps_data').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      setState(() {
        _stepsToday = 0;
        _progress = 0;
        _caloriesBurned = 0;
        _stepsHistory.clear(); // Clear the history as well
      });
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333), // Set background color for the dialog
          title: const Text(
            "Confirm Deletion",
            style: TextStyle(color: Colors.white), // Text color for the title
          ),
          content: const Text(
            "Are you sure you want to clear all data? This action cannot be undone.",
            style: TextStyle(color: Colors.white), // Text color for the content
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50), // Set background color for 'Cancel' button
                foregroundColor: Colors.white, // Set text color
              ),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog without deleting
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFF0000), // Set background color for 'Delete' button
                foregroundColor: Colors.white, // Set text color
              ),
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog and confirm deletion
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Steps Counter',
          style: TextStyle(color: Colors.white), // Light text color
        ),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41), // Dark background
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 40, 39, 41),
                Color.fromARGB(255, 0, 0, 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular Progress Widget (Unchanged)
                CustomCircularProgress(
                  progress: _progress.clamp(0.0, 1.0),
                  size: 150,
                  backgroundColor: const Color(0xFFD9D9D9), // Light grey
                  progressColor: const Color(0xFFFFC400), // Yellow
                ),
                const SizedBox(height: 20),
                Text(
                  '$_stepsToday steps',
                  style: const TextStyle(fontSize: 36, color: Colors.white),
                ),
                const SizedBox(height: 20),
                // Steps entry (Unchanged)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black, // Black background for input field
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _stepsController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: 'Enter steps',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Calories burned (Unchanged)
                Text(
                  '$_caloriesBurned calories burned',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                // Add steps button (Unchanged)
                ElevatedButton(
                  onPressed: _addStepsFromInput,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green button color
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add Steps', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                // Start/Stop Counting button
                ElevatedButton(
                  onPressed: _isCounting ? _stopCountingSteps : _startCountingSteps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCounting ? Colors.red : Color(0xFFF7BB0E), // Red for stop, blue for start
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _isCounting ? 'Stop Counting' : 'Start Counting',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                // Clear Data button
                ElevatedButton(
                  onPressed: _clearData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red button color
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Clear Data', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                // Chart widget added here
                SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat.MMMd(), // Format date as Month-Day
                    title: AxisTitle(text: 'Date'),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Steps'),
                  ),
                  title: ChartTitle(text: 'Steps History'),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries>[
                    LineSeries<Map<String, dynamic>, DateTime>(
                      dataSource: _stepsHistory,
                      xValueMapper: (Map<String, dynamic> data, _) {
                        final dateParts = data['date'].split('-');
                        return DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
                      },
                      yValueMapper: (Map<String, dynamic> data, _) => data['steps'],
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // Steps history list (Unchanged)
                SizedBox(
                  height: 200, // Prevent overflow by setting a height
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _stepsHistory.length,
                    itemBuilder: (context, index) {
                      final history = _stepsHistory[index];
                      return ListTile(
                        title: Text(
                          '${history['date']}: ${history['steps']} steps',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
