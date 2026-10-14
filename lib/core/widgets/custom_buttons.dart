import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'google_logo.dart';

/// Primary Filled Button (defaults to Dark Black, customizable to White for dark backgrounds).
class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final bool fullWidth;
  final Widget? leading;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryBlack,
    this.textColor = Colors.white,
    this.height = 56.0,
    this.borderRadius = 16.0,
    this.fullWidth = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: AppTypography.buttonText.copyWith(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );

    return button;
  }
}

/// Outlined Button with solid border and transparent/white background.
class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final double height;
  final double borderRadius;
  final bool fullWidth;

  const CustomOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor = AppColors.borderBlack,
    this.textColor = AppColors.textPrimary,
    this.backgroundColor = Colors.white,
    this.height = 56.0,
    this.borderRadius = 16.0,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Text(
          text,
          style: AppTypography.buttonText.copyWith(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

/// Google SSO Button with Google Vector Icon.
class GoogleAuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const GoogleAuthButton({
    super.key,
    required this.onPressed,
    this.text = 'Google',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.0,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: const BorderSide(color: Color(0xFFF0F0F2), width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GoogleLogo(size: 20),
              const SizedBox(width: 12),
              Text(
                text,
                style: AppTypography.buttonText.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dual Bottom Action Bar for navigation (Back & Next).
class NavigationBottomBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String backText;
  final String nextText;

  const NavigationBottomBar({
    super.key,
    required this.onBack,
    required this.onNext,
    this.backText = 'Back',
    this.nextText = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomOutlineButton(
              text: backText,
              onPressed: onBack,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomPrimaryButton(
              text: nextText,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}
