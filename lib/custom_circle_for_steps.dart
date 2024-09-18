import 'package:flutter/material.dart';

class CustomCircularProgress extends StatelessWidget {
  final double progress;
  final double size;
  final Color backgroundColor;
  final Color progressColor;

  const CustomCircularProgress({super.key, 
    required this.progress,
    required this.size,
    this.backgroundColor = const Color.fromARGB(255, 40, 39, 41),
    this.progressColor = const Color(0xFFF7BB0E),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          progress: progress,
          backgroundColor: backgroundColor,
          progressColor: progressColor,
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // Draw the background circle
    canvas.drawCircle(center, radius, paint);

    // Draw the progress circle
    paint.color = progressColor;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = 12;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * 3.14159 / 180,
      (progress * 360) * 3.14159 / 180,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
