import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Centralized SnackBar and Toast helper for Cardify.
/// Ensures all floating notifications and SnackBars are positioned safely
/// above the bottom navigation bar (92dp bottom margin) so they never overlap
/// or dock on top of navigation items.
class AppSnackBar {
  AppSnackBar._();

  /// Default bottom margin (92dp) ensuring notifications float safely above the 70-80dp bottom navigation bar.
  static const double bottomDockOffset = 92.0;

  /// Default horizontal margin for floating SnackBars.
  static const double horizontalMargin = 16.0;

  /// Creates a floating [SnackBar] configured to display safely above the bottom navigation bar.
  static SnackBar create({
    required Widget content,
    Color? backgroundColor,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = bottomDockOffset,
  }) {
    return SnackBar(
      content: content,
      backgroundColor: backgroundColor ?? AppColors.primaryBlack,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: horizontalMargin,
        right: horizontalMargin,
        bottom: bottomMargin,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 6,
      action: action,
      duration: duration,
    );
  }

  /// Displays a floating SnackBar safely above the bottom navigation bar.
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    IconData? icon,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = bottomDockOffset,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? AppColors.primaryBlack,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: horizontalMargin,
          right: horizontalMargin,
          bottom: bottomMargin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 6,
        action: action,
        duration: duration,
      ),
    );
  }
}
