import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WaveLinearProgressController extends ChangeNotifier {
  double progress = 0;
  double phase = 0;
  late Ticker ticker;

  WaveLinearProgressController() {
    ticker = Ticker((elapsed) {
      if (phase < 2 * pi) {
        phase += pi / 48;
      } else if (phase >= 2 * pi) {
        phase = 0;
      }
      notifyListeners();
    });
  }

  void setProgress(double newProgress) {
    progress = newProgress;
    notifyListeners();
  }

  void waveOn() {
    if (!ticker.isActive) {
      ticker.start();
    }
  }

  void waveOff() {
    ticker.stop();
  }

  @override
  void dispose() {
    super.dispose();
    ticker.dispose();
  }
}

class WaveLinearProgressIndicator extends StatelessWidget {
  const WaveLinearProgressIndicator({
    super.key,
    required this.controller,
  });

  final WaveLinearProgressController controller;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return CustomPaint(
      size: const Size(300.0, 0.0),
      painter: WaveLinearPainter(
        controller: controller,
        colorScheme: colorScheme,
      ),
    );
  }
}

class WaveLinearPainter extends CustomPainter {
  final WaveLinearProgressController controller;
  final ColorScheme colorScheme;
  WaveLinearPainter({required this.colorScheme, required this.controller})
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()..color = colorScheme.primary; //2080E5

    Path path = Path();
    path.moveTo(0, (size.height / 2) + 2.0);
    painter.strokeWidth = 4.0;

    ///波浪线条
    painter.style = PaintingStyle.stroke;
    for (double i = 1; i <= size.width * controller.progress; i += 1) {
      path.lineTo(
        i,
        2 * sin((2 * pi * i / 24.0) + controller.phase) +
            (size.height / 2) +
            2.0,
      );
    }
    canvas.drawPath(path, painter);

    ///未完成进度条
    painter.style = PaintingStyle.fill;
    painter.color = colorScheme.secondary;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * controller.progress,
        (size.height / 2),
        size.width * (1 - controller.progress),
        4.0,
      ),
      painter,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width, (size.height / 2) + 2.0),
          width: 4.0,
          height: 4.0,
        ),
        const Radius.circular(2.0),
      ),
      painter,
    );

    ///滑块
    painter.color = colorScheme.primary;
    canvas.drawCircle(
      Offset(size.width * controller.progress, (size.height / 2) + 2.0),
      8.0,
      painter,
    );
    // print((size.width * controller.progress).toStringAsFixed(2));
  }

  @override
  bool shouldRepaint(covariant WaveLinearPainter oldDelegate) => false;
}
