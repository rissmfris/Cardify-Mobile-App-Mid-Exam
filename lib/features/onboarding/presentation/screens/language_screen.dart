import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/cardify_tab_clipper.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/flag_icons.dart';
import '../../models/language_option.dart';

/// SCREEN 2 - Select Language
/// Derived from PDF Page 3:
/// - Header: "Select Language"
/// - Sub-header: "Select your language."
/// - Options: "Bahasa Indonesia" (active state) and "English (UK)"
/// - Navigation: "Back" and "Next"
class LanguageScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final ValueChanged<AppLanguage>? onLanguageChanged;
  final AppLanguage initialLanguage;

  const LanguageScreen({
    super.key,
    required this.onBack,
    required this.onNext,
    this.onLanguageChanged,
    this.initialLanguage = AppLanguage.indonesian,
  });

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late AppLanguage _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;
  }

  void _selectLanguage(AppLanguage language) {
    setState(() {
      _selectedLanguage = language;
    });
    widget.onLanguageChanged?.call(language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Top Section (Continuity with Dark Theme)
            Expanded(
              flex: 4,
              child: Container(
                color: AppColors.backgroundDark,
                width: double.infinity,
              ),
            ),

            // Bottom Section with Signature Folder Tab Shape in White
            Expanded(
              flex: 8,
              child: CardifyTabSheet(
                backgroundColor: AppColors.backgroundLight,
                tabWidthFraction: 0.65,
                stepHeight: 34.0,
                padding: const EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Select Language',
                      style: AppTypography.pageHeader.copyWith(
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Sub-header
                    Text(
                      'Select your language.',
                      style: AppTypography.bodyMuted.copyWith(
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Language Option 1: Bahasa Indonesia
                    _buildLanguageCard(
                      language: AppLanguage.indonesian,
                      title: 'Bahasa Indonesia',
                      flagWidget: const IndonesianFlag(size: 32),
                      isSelected: _selectedLanguage == AppLanguage.indonesian,
                    ),

                    const SizedBox(height: 16),

                    // Language Option 2: English (UK)
                    _buildLanguageCard(
                      language: AppLanguage.englishUK,
                      title: 'English (UK)',
                      flagWidget: const UkFlag(size: 32),
                      isSelected: _selectedLanguage == AppLanguage.englishUK,
                    ),

                    const Spacer(),

                    // Navigation Actions (Back & Next)
                    Row(
                      children: [
                        Expanded(
                          child: CustomOutlineButton(
                            text: 'Back',
                            onPressed: widget.onBack,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomPrimaryButton(
                            text: 'Next',
                            onPressed: widget.onNext,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required AppLanguage language,
    required String title,
    required Widget flagWidget,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _selectLanguage(language),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlack : Colors.transparent,
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0x1F000000) : const Color(0x0C000000),
              blurRadius: isSelected ? 14 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            flagWidget,
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
