import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/flag_icons.dart';

/// Modal dialog for "Choose Language".
/// Derived from Screen 4 in the design PDF.
class ChooseLanguageModal extends StatelessWidget {
  final ValueChanged<String> onLanguageSelected;

  const ChooseLanguageModal({
    super.key,
    required this.onLanguageSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String> onLanguageSelected,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) => ChooseLanguageModal(
        onLanguageSelected: (lang) {
          Navigator.pop(context);
          onLanguageSelected(lang);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title: "Choose Language"
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Choose Language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF0F0F2),
            ),

            // Option 1: Bahasa Indonesia
            InkWell(
              onTap: () => onLanguageSelected('Bahasa Indonesia'),
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IndonesianFlag(size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Bahasa Indonesia',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF0F0F2),
            ),

            // Option 2: English (UK)
            InkWell(
              onTap: () => onLanguageSelected('English (UK)'),
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UkFlag(size: 24),
                    SizedBox(width: 12),
                    Text(
                      'English (UK)',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
