import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Cardify Brand Logo Widget displaying the iconic rounded C badge and 'Cardify' typography.
class CardifyLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final Color textColor;
  final Color badgeColor;
  final Color symbolColor;
  final bool showText;
  final MainAxisSize mainAxisSize;

  const CardifyLogo({
    super.key,
    this.iconSize = 36.0,
    this.fontSize = 26.0,
    this.textColor = AppColors.textPrimary,
    this.badgeColor = AppColors.primaryBlack,
    this.symbolColor = Colors.white,
    this.showText = true,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Rounded C Icon Box
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(iconSize * 0.28),
          ),
          child: Center(
            child: Text(
              'C',
              style: TextStyle(
                color: symbolColor,
                fontSize: iconSize * 0.58,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 10),
          Text(
            'Cardify',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}
