import 'package:flutter/material.dart';

/// Custom clipper that creates the signature Cardify folder tab shape.
class CardifyTabClipper extends CustomClipper<Path> {
  final double tabWidthFraction;
  final double stepHeight;
  final double cornerRadius;

  const CardifyTabClipper({
    this.tabWidthFraction = 0.65,
    this.stepHeight = 36.0,
    this.cornerRadius = 24.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final tabW = size.width * tabWidthFraction;
    final r = cornerRadius;
    final h = stepHeight;

    // Start top-left
    path.moveTo(0, 0);
    // Line to start of top-right curve of tab
    path.lineTo(tabW - r, 0);
    // Convex curve rounding the top-right corner of tab
    path.quadraticBezierTo(tabW, 0, tabW, r);
    // Vertical line dropping down to step
    path.lineTo(tabW, h - r);
    // Concave curve transitioning to horizontal lower ledge
    path.quadraticBezierTo(tabW, h, tabW + r, h);
    // Line across to right edge
    path.lineTo(size.width, h);
    // Line down to bottom-right
    path.lineTo(size.width, size.height);
    // Line across to bottom-left
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CardifyTabClipper oldClipper) =>
      oldClipper.tabWidthFraction != tabWidthFraction ||
      oldClipper.stepHeight != stepHeight ||
      oldClipper.cornerRadius != cornerRadius;
}

/// A container widget styled with the Cardify tab outline and background.
class CardifyTabSheet extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final double tabWidthFraction;
  final double stepHeight;
  final EdgeInsetsGeometry padding;

  const CardifyTabSheet({
    super.key,
    required this.backgroundColor,
    required this.child,
    this.tabWidthFraction = 0.65,
    this.stepHeight = 36.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CardifyTabClipper(
        tabWidthFraction: tabWidthFraction,
        stepHeight: stepHeight,
      ),
      child: Container(
        color: backgroundColor,
        width: double.infinity,
        padding: padding,
        child: child,
      ),
    );
  }
}
