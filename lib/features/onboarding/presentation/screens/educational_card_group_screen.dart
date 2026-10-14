import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../widgets/academic_card_preview.dart';
import '../widgets/onboarding_header_bar.dart';

/// SCREEN 3 - Educational Flow 1 ("What is Card & Group?")
/// Derived from PDF Page 4:
/// - Header: "What is Card Group & Card?" + Skip option
/// - Section A ("Card?"): Description + Academic Card Preview
/// - Section B ("Card Group?"): Description + Academic Card Group Preview
/// - Navigation: "Back", "Next", and "Skip"
class EducationalCardGroupScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const EducationalCardGroupScreen({
    super.key,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Title Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: OnboardingHeaderBar(
                title: 'What is Card\nGroup & Card?',
                showSkip: true,
                onSkip: onSkip,
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section A: Card?
                    Text(
                      'Card?',
                      style: AppTypography.sectionTitle.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Card is main feature on Cardify, it helps you tracking your tasks.',
                      style: AppTypography.bodyMuted.copyWith(
                        color: const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Academic Card Preview Widget
                    const AcademicCardPreview(),

                    const SizedBox(height: 28),

                    // Section B: Card Group?
                    Text(
                      'Card Group?',
                      style: AppTypography.sectionTitle.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Card Group contain many of card based on it's category (Academic & Organization)",
                      style: AppTypography.bodyMuted.copyWith(
                        color: const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Academic Card Group Preview Widget
                    const AcademicGroupPreview(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Buttons
            NavigationBottomBar(
              onBack: onBack,
              onNext: onNext,
            ),
          ],
        ),
      ),
    );
  }
}
