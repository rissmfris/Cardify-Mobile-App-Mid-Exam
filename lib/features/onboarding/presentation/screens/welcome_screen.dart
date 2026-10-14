import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/cardify_logo.dart';
import '../../../../core/widgets/cardify_tab_clipper.dart';
import '../../../../core/widgets/custom_buttons.dart';

/// SCREEN 1 - Splash / Welcome Screen
/// Derived from PDF Pages 1 & 2:
/// - Header/Branding: "Cardify" text & logo
/// - Hero text: "Welcome to Cardify"
/// - Sub-text: "Let's set your Card."
/// - Action buttons: Elevated button "Get Started", and a "Skip" option.
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSkip;
  final VoidCallback? onPreviewSplash;

  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
    required this.onSkip,
    this.onPreviewSplash,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Top Section with Cardify Branding
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CardifyLogo(
                        iconSize: 48,
                        fontSize: 34,
                      ),
                      if (onPreviewSplash != null) ...[
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: onPreviewSplash,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Tap to preview Splash Logo',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Section with Cardify Signature Tab Sheet in Dark
            Expanded(
              flex: 6,
              child: CardifyTabSheet(
                backgroundColor: AppColors.backgroundDark,
                tabWidthFraction: 0.65,
                stepHeight: 34.0,
                padding: const EdgeInsets.fromLTRB(28.0, 48.0, 28.0, 36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Title
                    const Text(
                      'Welcome to Cardify',
                      style: AppTypography.heroTitle,
                    ),
                    const SizedBox(height: 8),

                    // Sub-text
                    Text(
                      "Let's set your Card.",
                      style: AppTypography.bodyOnDark.copyWith(
                        fontSize: 16,
                        color: const Color(0xFFD1D5DB),
                      ),
                    ),

                    const Spacer(),

                    // Elevated Button "Get Started"
                    CustomPrimaryButton(
                      text: 'Get Started',
                      backgroundColor: Colors.white,
                      textColor: AppColors.primaryBlack,
                      onPressed: onGetStarted,
                    ),

                    const SizedBox(height: 16),

                    // Skip Option
                    Center(
                      child: TextButton(
                        onPressed: onSkip,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Skip',
                          style: AppTypography.buttonText.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
