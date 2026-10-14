import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/custom_text_field.dart';

/// SCREEN 2 - Add Card Group
/// Derived from PDF Page 3:
/// - Header: "< Add Card Group"
/// - Group Card Name: "Organization"
/// - Category Name items with red '-' remove pills
/// - "+ Add Category" button
/// - Footer buttons: "Save" (Black) and "Cancel" (Light)
class AddCardGroupScreen extends StatefulWidget {
  final VoidCallback? onSaved;
  final VoidCallback? onCancelled;

  const AddCardGroupScreen({
    super.key,
    this.onSaved,
    this.onCancelled,
  });

  @override
  State<AddCardGroupScreen> createState() => _AddCardGroupScreenState();
}

class _AddCardGroupScreenState extends State<AddCardGroupScreen> {
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
    final suggestions = [
      'Komunitas Seni',
      'Himpunan Mahasiswa',
      'Unit Olahraga',
      'Club Debat',
    ];
    final candidate = suggestions.firstWhere(
      (s) => !_categories.contains(s),
      orElse: () => 'Kategori Baru ${_categories.length + 1}',
    );

    setState(() {
      _categories.add(candidate);
    });
  }

  void _handleSave() {
    final groupName = _groupNameController.text.trim();
    if (groupName.isEmpty) {
      AppSnackBar.show(
        context,
        message: 'Please enter a Group Card Name',
        backgroundColor: AppColors.urgentRed,
        icon: Icons.error_outline_rounded,
      );
      return;
    }

    AppSnackBar.show(
      context,
      message: 'Card Group "$groupName" added successfully!',
      icon: Icons.check_circle_outline_rounded,
    );

    if (widget.onSaved != null) {
      widget.onSaved!();
    } else {
      Navigator.pop(context);
    }
  }

  void _handleCancel() {
    if (widget.onCancelled != null) {
      widget.onCancelled!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: SafeArea(
            child: Column(
              children: [
                // Header Bar: "< Add Card Group"
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 14.0, 24.0, 12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _handleCancel,
                        behavior: HitTestBehavior.opaque,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 4.0),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Add Card Group',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        // Group Card Name Label & Field
                        CustomTextField(
                          label: 'Group Card Name',
                          hintText: 'Insert Group Card Name',
                          controller: _groupNameController,
                        ),

                        const SizedBox(height: 24),

                        // Category Name Label
                        Text(
                          'Category Name',
                          style: AppTypography.inputLabel.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Dynamic Category List
                        ..._categories.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final String categoryName = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                // Text Box
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0,
                                      vertical: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16.0),
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

                                // Red Remove Pill Button
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

                        const SizedBox(height: 36),

                        // Footer Action Buttons: Save & Cancel
                        CustomPrimaryButton(
                          text: 'Save',
                          onPressed: _handleSave,
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 54.0,
                          child: TextButton(
                            onPressed: _handleCancel,
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F4F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
