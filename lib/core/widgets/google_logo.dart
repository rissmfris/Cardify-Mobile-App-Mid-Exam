import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Crisp vector Google 'G' logo painted with standard brand colors.
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final double center = s / 2;
    final double strokeWidth = s * 0.22;
    final double radius = (s - strokeWidth) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(center: Offset(center, center), radius: radius);

    // Red arc (top-right to top-left)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -math.pi / 4, -math.pi * 0.55, false, paint);

    // Yellow arc (left side)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, -math.pi * 0.8, -math.pi * 0.45, false, paint);

    // Green arc (bottom side)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, -math.pi * 1.25, -math.pi * 0.55, false, paint);

    // Blue arc (bottom right to horizontal bar)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, 0.0, math.pi * 0.2, false, paint);

    // Blue horizontal crossbar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final barRect = Rect.fromLTWH(
      center - strokeWidth * 0.1,
      center - strokeWidth / 2,
      center + strokeWidth / 2,
      strokeWidth,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
