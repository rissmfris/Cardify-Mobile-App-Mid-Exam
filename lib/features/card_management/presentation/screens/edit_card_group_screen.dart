import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../models/card_group.dart';

/// SCREEN 3 - Edit Card Group
/// Derived from PDF Page 4:
/// - Header: "< Edit Card Group"
/// - Group Card Name: "Campus Organization"
/// - Sub Group Card Name items: "Himapedia", "Badan Eksekutif Mahasiswa (BEM)", "PERSLIMA"
/// - "+ Add Category" button
/// - Footer buttons: "Save Changes" and "Cancel"
class EditCardGroupScreen extends StatefulWidget {
  final CardGroup? group;
  final VoidCallback? onSaved;
  final VoidCallback? onCancelled;

  const EditCardGroupScreen({
    super.key,
    this.group,
    this.onSaved,
    this.onCancelled,
  });

  @override
  State<EditCardGroupScreen> createState() => _EditCardGroupScreenState();
}

class _EditCardGroupScreenState extends State<EditCardGroupScreen> {
  late TextEditingController _groupNameController;
  late List<String> _subGroups;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController(
      text: widget.group?.title ?? 'Campus Organization',
    );
    _subGroups = widget.group?.items.isNotEmpty == true
        ? List.from(widget.group!.items)
        : [
            'Himapedia',
            'Badan Eksekutif Mahasiswa (BEM)',
            'PERSLIMA',
          ];
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _removeSubGroup(int index) {
    setState(() {
      _subGroups.removeAt(index);
    });
  }

  void _addSubGroup() {
    final suggestions = [
      'Dapur Seni Biru',
      'Himpunan Mahasiswa',
      'Unit Olahraga',
    ];
    final candidate = suggestions.firstWhere(
      (s) => !_subGroups.contains(s),
      orElse: () => 'Sub Kategori ${_subGroups.length + 1}',
    );

    setState(() {
      _subGroups.add(candidate);
    });
  }

  void _handleSaveChanges() {
    final name = _groupNameController.text.trim();
    AppSnackBar.show(
      context,
      message: 'Changes to "$name" saved successfully!',
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
                // Header Bar: "< Edit Card Group"
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
                          'Edit Card Group',
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

                        // Group Card Name
                        CustomTextField(
                          label: 'Group Card Name',
                          hintText: 'Group Card Name',
                          controller: _groupNameController,
                        ),

                        const SizedBox(height: 24),

                        // Sub Group Card Name Label
                        Text(
                          'Sub Group Card Name',
                          style: AppTypography.inputLabel.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Sub Group List Items
                        ..._subGroups.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final String item = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
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
                                      item,
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
                                  onTap: () => _removeSubGroup(index),
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
                          onPressed: _addSubGroup,
                          borderRadius: 16.0,
                          height: 52.0,
                        ),

                        const SizedBox(height: 36),

                        // Footer Action Buttons: Save Changes & Cancel
                        CustomPrimaryButton(
                          text: 'Save Changes',
                          onPressed: _handleSaveChanges,
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
