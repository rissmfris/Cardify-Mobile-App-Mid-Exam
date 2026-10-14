import 'package:flutter/material.dart';

/// Clean circular vector flags for language selection.
class IndonesianFlag extends StatelessWidget {
  final double size;

  const IndonesianFlag({super.key, this.size = 28.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Column(
          children: [
            Expanded(
              child: Container(color: const Color(0xFFE11D48)), // Indonesian Red
            ),
            Expanded(
              child: Container(color: Colors.white), // Indonesian White
            ),
          ],
        ),
      ),
    );
  }
}

class UkFlag extends StatelessWidget {
  final double size;

  const UkFlag({super.key, this.size = 28.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size),
          painter: _UkFlagPainter(),
        ),
      ),
    );
  }
}

class _UkFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Rect rect = Rect.fromLTWH(0, 0, w, h);

    // Blue field
    final bluePaint = Paint()..color = const Color(0xFF012169);
    canvas.drawRect(rect, bluePaint);

    final whitePaint = Paint()..color = Colors.white;
    final redPaint = Paint()..color = const Color(0xFFC8102E);

    // Diagonals (White broad saltire)
    final whiteDiagonalPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = w * 0.22
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(w, h), whiteDiagonalPaint);
    canvas.drawLine(Offset(0, h), Offset(w, 0), whiteDiagonalPaint);

    // Diagonals (Red narrow saltire)
    final redDiagonalPaint = Paint()
      ..color = const Color(0xFFC8102E)
      ..strokeWidth = w * 0.09
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(w, h), redDiagonalPaint);
    canvas.drawLine(Offset(0, h), Offset(w, 0), redDiagonalPaint);

    // White cross (St. George fimbriation)
    final whiteCrossWidth = w * 0.32;
    canvas.drawRect(
      Rect.fromLTWH((w - whiteCrossWidth) / 2, 0, whiteCrossWidth, h),
      whitePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, (h - whiteCrossWidth) / 2, w, whiteCrossWidth),
      whitePaint,
    );

    // Red cross (St. George)
    final redCrossWidth = w * 0.18;
    canvas.drawRect(
      Rect.fromLTWH((w - redCrossWidth) / 2, 0, redCrossWidth, h),
      redPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, (h - redCrossWidth) / 2, w, redCrossWidth),
      redPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
