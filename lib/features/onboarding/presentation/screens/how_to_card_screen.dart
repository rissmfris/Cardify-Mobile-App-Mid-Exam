import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../widgets/onboarding_header_bar.dart';

/// SCREEN 5 - Educational Flow 3 ("How to Card")
/// Derived from PDF Page 6:
/// - Header: "How to Card" + Skip option
/// - Sub-header: "Add & Edit Card"
/// - Instructional text: "Add your Card and it's details."
/// - Form fields mockup:
///   - Assignment Name ("Membuat Nirmana Titik")
///   - Subject dropdown ("Nirmana")
///   - Description ("Add some detail of this assignment")
///   - Deadline: Time ("00:00") & Date ("Select a date")
/// - Navigation: "Back", "Next", and "Skip"
class HowToCardScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const HowToCardScreen({
    super.key,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
  });

  @override
  State<HowToCardScreen> createState() => _HowToCardScreenState();
}

class _HowToCardScreenState extends State<HowToCardScreen> {
  final TextEditingController _assignmentController =
      TextEditingController(text: 'Membuat Nirmana Titik');
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedSubject = 'Nirmana';
  final List<String> _subjects = [
    'Nirmana',
    'Teknologi Imersif',
    'Pemrograman Berorientasi Objek',
    'Desain Grafis',
  ];

  String _timeString = '00:00';
  String _dateString = 'Select a date';

  @override
  void dispose() {
    _assignmentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _timeString =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        final months = [
          'Januari',
          'Februari',
          'Maret',
          'April',
          'Mei',
          'Juni',
          'Juli',
          'Agustus',
          'September',
          'Oktober',
          'November',
          'Desember'
        ];
        _dateString = '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      });
    }
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
                title: 'How to Card',
                showSkip: true,
                onSkip: widget.onSkip,
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle
                    Text(
                      'Add & Edit Card',
                      style: AppTypography.sectionTitle.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Add your Card and it's details.",
                      style: AppTypography.bodyMuted.copyWith(
                        color: const Color(0xFF374151),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 1. Assignment Name
                    Text(
                      'Assignment Name',
                      style: AppTypography.inputLabel.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                        _assignmentController.text,
                        style: AppTypography.inputText.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 2. Subject Dropdown
                    Text(
                      'Subject',
                      style: AppTypography.inputLabel.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: AppColors.primaryBlack,
                          width: 1.4,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSubject,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primaryBlack,
                            size: 24,
                          ),
                          isExpanded: true,
                          style: AppTypography.inputText.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedSubject = newValue;
                              });
                            }
                          },
                          items: _subjects.map((String subject) {
                            return DropdownMenuItem<String>(
                              value: subject,
                              child: Text(subject),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 3. Description Field
                    Text(
                      'Description',
                      style: AppTypography.inputLabel.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 110,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 14.0,
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
                        'Add some detail of this assignment',
                        style: AppTypography.placeholder.copyWith(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 4. Deadline (Time & Date Pickers)
                    Text(
                      'Deadline',
                      style: AppTypography.inputLabel.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Time Picker
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: _pickTime,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
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
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _timeString,
                                    style: AppTypography.inputText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Date Picker
                        Expanded(
                          flex: 6,
                          child: GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
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
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      _dateString,
                                      style: AppTypography.inputText.copyWith(
                                        color: _dateString == 'Select a date'
                                            ? const Color(0xFF9CA3AF)
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
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
