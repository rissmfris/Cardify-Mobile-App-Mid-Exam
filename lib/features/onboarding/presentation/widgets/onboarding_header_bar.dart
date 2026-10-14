import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

/// Top header bar for onboarding screens supporting back navigation, title, and Skip button.
class OnboardingHeaderBar extends StatelessWidget {
  final String? title;
  final bool showBack;
  final String? backTitle;
  final VoidCallback? onBack;
  final bool showSkip;
  final VoidCallback? onSkip;
  final Color contentColor;

  const OnboardingHeaderBar({
    super.key,
    this.title,
    this.showBack = false,
    this.backTitle,
    this.onBack,
    this.showSkip = false,
    this.onSkip,
    this.contentColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Back button or Title
          if (showBack)
            GestureDetector(
              onTap: onBack,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: contentColor,
                  ),
                  if (backTitle != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      backTitle!,
                      style: AppTypography.pageHeader.copyWith(
                        color: contentColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            )
          else if (title != null)
            Expanded(
              child: Text(
                title!,
                style: AppTypography.pageHeader.copyWith(
                  color: contentColor,
                ),
              ),
            )
          else
            const SizedBox.shrink(),

          // Right: Skip button
          if (showSkip)
            TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: contentColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Skip',
                style: AppTypography.buttonText.copyWith(
                  color: contentColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
