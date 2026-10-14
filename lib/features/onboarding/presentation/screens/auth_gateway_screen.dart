import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/cardify_tab_clipper.dart';
import '../../../../core/widgets/custom_buttons.dart';

/// SCREEN 6 - Auth Gateway (Welcome Options)
/// Derived from PDF Page 7:
/// - Top: Dark background
/// - Bottom Tab Sheet: White
/// - Greeting: "Welcome,"
/// - Sub-text: "Choose of how you want to step in."
/// - Action buttons: "Sign In" (Primary) and "Sign Up" (Secondary/Outline)
class AuthGatewayScreen extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback? onBack;

  const AuthGatewayScreen({
    super.key,
    required this.onSignIn,
    required this.onSignUp,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Top Section (Dark theme continuity)
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    color: AppColors.backgroundDark,
                    width: double.infinity,
                  ),
                  if (onBack != null)
                    Positioned(
                      top: 48,
                      left: 20,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: onBack,
                      ),
                    ),
                ],
              ),
            ),

            // Bottom Section with Signature Folder Tab Sheet in White
            Expanded(
              flex: 5,
              child: CardifyTabSheet(
                backgroundColor: AppColors.backgroundLight,
                tabWidthFraction: 0.65,
                stepHeight: 34.0,
                padding: const EdgeInsets.fromLTRB(28.0, 48.0, 28.0, 36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Text(
                      'Welcome,',
                      style: AppTypography.pageHeader.copyWith(
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Sub-text
                    Text(
                      'Choose of how you want to step in.',
                      style: AppTypography.bodyMuted.copyWith(
                        fontSize: 15,
                        color: const Color(0xFF6B7280),
                      ),
                    ),

                    const Spacer(),

                    // Primary Button: "Sign In"
                    CustomPrimaryButton(
                      text: 'Sign In',
                      onPressed: onSignIn,
                    ),

                    const SizedBox(height: 16),

                    // Secondary Button: "Sign Up"
                    CustomOutlineButton(
                      text: 'Sign Up',
                      onPressed: onSignUp,
                    ),

                    const SizedBox(height: 16),
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
