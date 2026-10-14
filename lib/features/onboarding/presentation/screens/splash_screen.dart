import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/cardify_logo.dart';

/// Standalone Splash Screen matching PDF Page 1:
/// Minimalist centered Cardify logo on clean light background.
class SplashScreen extends StatelessWidget {
  final VoidCallback? onDismiss;

  const SplashScreen({super.key, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CardifyLogo(
                iconSize: 52,
                fontSize: 36,
              ),
              const SizedBox(height: 24),
              if (onDismiss != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Tap anywhere to continue',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
