import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wave_progress_indicator/wave_progress_indicator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final duration = const Duration(minutes: 3, seconds: 50);
  var position = Duration.zero;
  final controller = WaveLinearProgressController();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      position += const Duration(milliseconds: 200);
      var progress = position.inMilliseconds / duration.inMilliseconds;
      if (progress >= 1) {
        timer.cancel();
        controller.waveOff();
        return;
      }
      controller.setProgress(progress);
    });
    controller.waveOn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all()
              ),
              child: WaveLinearProgressIndicator(controller: controller),
            ),
          ),
        ),
      ),
    );
  }
}
