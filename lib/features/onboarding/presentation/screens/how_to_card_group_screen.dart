import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../widgets/onboarding_header_bar.dart';

/// SCREEN 4 - Educational Flow 2 ("How to Card Group?")
/// Derived from PDF Page 5:
/// - Header: "How to Card Group?" + Skip option
/// - Sub-header: "Add Card Group"
/// - Instructional text: "Starting by naming your Card Group..."
/// - Form mockup:
///   - Group Card Name ("Organization")
///   - Category Name items: "Himapedia", "Badan Eksekutif Mahasiswa (BEM)", "PERSLIMA", "Dapur Seni Biru"
///   - Red "-" remove pills
///   - "+ Add Category" action button
/// - Navigation: "Back", "Next", and "Skip"
class HowToCardGroupScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const HowToCardGroupScreen({
    super.key,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
  });

  @override
  State<HowToCardGroupScreen> createState() => _HowToCardGroupScreenState();
}

class _HowToCardGroupScreenState extends State<HowToCardGroupScreen> {
  final TextEditingController _groupNameController =
      TextEditingController(text: 'Organization');

  final List<String> _categories = [
    'Himapedia',
    'Badan Eksekutif Mahasiswa (BEM)',
    'PERSLIMA',
    'Dapur Seni Biru',
  ];

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _removeCategory(int index) {
    setState(() {
      _categories.removeAt(index);
    });
  }

  void _addCategory() {
    final newOptions = [
      'Komunitas Seni',
      'Himpunan Mahasiswa',
      'Club Debat',
      'Unit Olahraga',
    ];
    final candidate = newOptions.firstWhere(
      (opt) => !_categories.contains(opt),
      orElse: () => 'Kategori Baru ${_categories.length + 1}',
    );

    setState(() {
      _categories.add(candidate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: OnboardingHeaderBar(
                title: 'How to Card Group?',
                showSkip: true,
                onSkip: widget.onSkip,
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
                    // Subtitle
                    Text(
                      'Add Card Group',
                      style: AppTypography.sectionTitle.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Starting by naming your Card Group, then fill it's Card Group with Category, it can be Subject or Organization Name.",
                      style: AppTypography.bodyMuted.copyWith(
                        color: const Color(0xFF374151),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Group Card Name Label
                    Text(
                      'Group Card Name',
                      style: AppTypography.inputLabel.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Group Card Name Input Field
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: AppColors.primaryBlack,
                          width: 1.4,
                        ),
                      ),
                      child: Text(
                        _groupNameController.text,
                        style: AppTypography.inputText.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Category Name Label
                    Text(
                      'Category Name',
                      style: AppTypography.inputLabel.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Category items list
                    ..._categories.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final String categoryName = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            // Text box
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  vertical: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: AppColors.primaryBlack,
                                    width: 1.4,
                                  ),
                                ),
                                child: Text(
                                  categoryName,
                                  style: AppTypography.inputText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Red Remove Pill Button with white minus sign
                            GestureDetector(
                              onTap: () => _removeCategory(index),
                              child: Container(
                                width: 44,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.deleteButtonRed,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: const Center(
                                  child: Text(
                                    '—',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 8),

                    // "+ Add Category" button
                    CustomPrimaryButton(
                      text: '+ Add Category',
                      onPressed: _addCategory,
                      borderRadius: 16.0,
                      height: 52.0,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Buttons
            NavigationBottomBar(
              onBack: widget.onBack,
              onNext: widget.onNext,
            ),
          ],
        ),
      ),
    );
  }
}
