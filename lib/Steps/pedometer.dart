import 'package:pedometer/pedometer.dart';
import 'dart:async';

class PedometerService {
  static final PedometerService _instance = PedometerService._internal();

  factory PedometerService() {
    return _instance;
  }

  PedometerService._internal();

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  int _stepsToday = 0;

  bool isCounting = false;

  // Function to initialize pedometer and start counting steps
  void startListeningToSteps(void Function(int) onStepCountChanged) {
    if (isCounting) return;

    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

    _stepCountSubscription = _stepCountStream.listen((StepCount event) {
      // Update steps and call the callback function with new step count
      _stepsToday = event.steps;
      onStepCountChanged(_stepsToday);
    }, onError: (error) {
      print('Pedometer Error: $error');
    });

    _pedestrianStatusSubscription = _pedestrianStatusStream.listen((PedestrianStatus event) {
      print('Pedestrian Status: ${event.status}');
    }, onError: (error) {
      print('Pedestrian Status Error: $error');
    });

    isCounting = true;
  }

  // Function to stop listening to steps
  void stopListeningToSteps() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    isCounting = false;
    print('Stopped listening to steps');
  }

  int get stepsToday => _stepsToday;
}
