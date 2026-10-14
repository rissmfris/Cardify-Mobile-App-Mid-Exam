import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

/// Custom painter that draws the signature Cardify sad-faced folder icon
/// matching the empty state design specification.
class SadFolderPainter extends CustomPainter {
  final Color folderColor;
  final Color faceColor;

  const SadFolderPainter({
    this.folderColor = AppColors.primaryBlack,
    this.faceColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Proportional dimensions for folder shape
    final tabWidth = w * 0.58;
    final stepHeight = h * 0.22;
    final outerRadius = w * 0.10;
    final tabRightRadius = w * 0.08;
    final innerRadius = w * 0.07;
    final bottomRadius = w * 0.11;

    // 1. Draw Folder Body & Tab Path
    final folderPath = Path();

    // Start at top-left corner (below rounding)
    folderPath.moveTo(0, outerRadius);
    // Rounded top-left corner of tab
    folderPath.quadraticBezierTo(0, 0, outerRadius, 0);
    // Top horizontal edge of tab
    folderPath.lineTo(tabWidth - tabRightRadius, 0);
    // Rounded top-right corner of tab
    folderPath.quadraticBezierTo(tabWidth, 0, tabWidth, tabRightRadius);
    // Vertical drop down to the right ledge
    folderPath.lineTo(tabWidth, stepHeight - innerRadius);
    // Concave transition into the right ledge
    folderPath.quadraticBezierTo(
      tabWidth,
      stepHeight,
      tabWidth + innerRadius,
      stepHeight,
    );
    // Horizontal ledge to top-right corner
    folderPath.lineTo(w - outerRadius, stepHeight);
    // Rounded top-right corner of main body
    folderPath.quadraticBezierTo(w, stepHeight, w, stepHeight + outerRadius);
    // Right vertical edge
    folderPath.lineTo(w, h - bottomRadius);
    // Rounded bottom-right corner
    folderPath.quadraticBezierTo(w, h, w - bottomRadius, h);
    // Bottom horizontal edge
    folderPath.lineTo(bottomRadius, h);
    // Rounded bottom-left corner
    folderPath.quadraticBezierTo(0, h, 0, h - bottomRadius);
    // Left vertical edge back up to start
    folderPath.lineTo(0, outerRadius);
    folderPath.close();

    final folderPaint = Paint()
      ..color = folderColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(folderPath, folderPaint);

    // 2. Draw Sad Face Features (Two round eyes and a downward frown)
    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final centerX = w * 0.5;
    // Visually center the face inside the main folder body area
    final eyesY = h * 0.52;
    final eyeRadius = w * 0.038;
    final eyeSpacing = w * 0.125;

    // Left eye
    canvas.drawCircle(Offset(centerX - eyeSpacing, eyesY), eyeRadius, facePaint);
    // Right eye
    canvas.drawCircle(Offset(centerX + eyeSpacing, eyesY), eyeRadius, facePaint);

    // Sad mouth (frown / downward curved arc)
    final mouthStrokePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.028
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final mouthWidth = w * 0.20;
    final mouthY = h * 0.68;
    final mouthCurveHeight = h * 0.07;

    final mouthPath = Path();
    // Start at bottom-left corner of mouth
    mouthPath.moveTo(centerX - mouthWidth / 2, mouthY + mouthCurveHeight / 2);
    // Smooth quadratic curve upward to peak, then down to bottom-right
    mouthPath.quadraticBezierTo(
      centerX,
      mouthY - mouthCurveHeight * 1.5,
      centerX + mouthWidth / 2,
      mouthY + mouthCurveHeight / 2,
    );

    canvas.drawPath(mouthPath, mouthStrokePaint);
  }

  @override
  bool shouldRepaint(covariant SadFolderPainter oldDelegate) =>
      oldDelegate.folderColor != folderColor ||
      oldDelegate.faceColor != faceColor;
}

/// Standalone Sad Folder Icon Widget.
class SadFolderIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color folderColor;
  final Color faceColor;

  const SadFolderIcon({
    super.key,
    this.width = 124.0,
    this.height = 92.0,
    this.folderColor = AppColors.primaryBlack,
    this.faceColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: SadFolderPainter(
          folderColor: folderColor,
          faceColor: faceColor,
        ),
      ),
    );
  }
}

/// Reusable "Empty State" widget matching the Cardify design specification:
/// - Sad-faced folder icon
/// - Modern typography: "There's nothing to see here,\nadd some cards."
/// - Perfectly balanced vertical centering & padding
/// - Optional contextual message or action button
class EmptyStateWidget extends StatelessWidget {
  /// The empty state text message.
  /// Defaults to: "There's nothing to see here,\nadd some cards."
  final String message;

  /// Custom action widget (e.g., custom button), if any.
  final Widget? action;

  /// Optional action callback for a simple primary button.
  final VoidCallback? onAction;

  /// Optional label for the primary action button.
  final String? actionLabel;

  /// Width of the sad folder icon.
  final double iconWidth;

  /// Height of the sad folder icon.
  final double iconHeight;

  /// Folder fill color.
  final Color folderColor;

  /// Face features color.
  final Color faceColor;

  /// Padding around the entire empty state widget.
  final EdgeInsetsGeometry padding;

  const EmptyStateWidget({
    super.key,
    this.message = "There's nothing to see here,\nadd some cards.",
    this.action,
    this.onAction,
    this.actionLabel,
    this.iconWidth = 124.0,
    this.iconHeight = 92.0,
    this.folderColor = AppColors.primaryBlack,
    this.faceColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sad-faced Folder Icon
            SadFolderIcon(
              width: iconWidth,
              height: iconHeight,
              folderColor: folderColor,
              faceColor: faceColor,
            ),

            const SizedBox(height: 24.0),

            // Text Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.38,
                letterSpacing: -0.2,
              ),
            ),

            // Optional action button
            if (action != null) ...[
              const SizedBox(height: 20.0),
              action!,
            ] else if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlack,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
