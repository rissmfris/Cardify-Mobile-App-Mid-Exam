import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Circular profile avatar with water reflection styling and edit badge button.
/// Directly derived from Screen 1 (Profile Header) in the design PDF.
class ProfileAvatarHeader extends StatelessWidget {
  final VoidCallback onTapEdit;

  const ProfileAvatarHeader({
    super.key,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Circular Avatar Container
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: CustomPaint(
                size: const Size(96, 96),
                painter: _WaterRipplePainter(),
              ),
            ),
          ),

          // Edit / Pencil Overlay Badge (Bottom Right)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTapEdit,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlack,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter to reproduce the caustics/water ripple texture seen in the PDF avatar.
class _WaterRipplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Deep blue-grey water gradient background
    final rect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.2),
        radius: 0.9,
        colors: [
          Color(0xFF4A6572),
          Color(0xFF2C3E50),
          Color(0xFF1A252F),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // 2. Caustic light wave rings
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 7; i++) {
      final radius = 10.0 + (i * 7.0);
      final opacity = 0.25 + (math.sin(i.toDouble()) * 0.15);
      wavePaint
        ..color = Colors.white.withValues(alpha: opacity)
        ..strokeWidth = 1.2 + (i % 2) * 0.8;

      final path = Path();
      for (double angle = 0; angle <= 2 * math.pi; angle += 0.2) {
        final distortion = math.sin(angle * 5 + i) * 3.5;
        final r = radius + distortion;
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        if (angle == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, wavePaint);
    }

    // 3. Highlight shimmer across the surface
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
