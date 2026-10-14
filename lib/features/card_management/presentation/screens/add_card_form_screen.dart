import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/task_priority_badge.dart';
import '../../models/card_group.dart';

/// SCREEN 5 - Add Academic Card Form
/// Derived from PDF Page 7:
/// - Header: "< Add Academic Card"
/// - Inputs: Assignment Name ("Insert assignment"), Subject ("Nirmana"), Description ("Add some detail..."), Deadline (Time & Date)
/// - Action Button: "Add Cards"
class AddCardFormScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final ValueChanged<CardTask>? onCardAdded;

  const AddCardFormScreen({
    super.key,
    this.onBack,
    this.onCardAdded,
  });

  @override
  State<AddCardFormScreen> createState() => _AddCardFormScreenState();
}

class _AddCardFormScreenState extends State<AddCardFormScreen> {
  final TextEditingController _assignmentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _categoryName = 'Academic Card';
  String _selectedSubject = 'Nirmana';
  final List<String> _subjects = [
    'Nirmana',
    'Teknologi Imersif',
    'Pemrograman Berorientasi Objek',
    'Desain Grafis',
  ];

  String _timeString = '00:00';
  String _dateString = 'Select a date';
  DateTime? _selectedDate;
  bool _initialized = false;

  /// Priority is an automated frontend indicator calculated from deadline urgency.
  /// Reflects task deadline logic (handled by backend).
  String get _calculatedPriority {
    if (_selectedDate == null) return 'Urgent';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
    final daysDifference = target.difference(today).inDays;
    if (daysDifference <= 2) {
      return 'Urgent';
    } else if (daysDifference <= 7) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) {
        _categoryName = args;
      } else if (args is CardGroup) {
        _categoryName = args.title.replaceAll(' Group', '');
      }

      final lower = _categoryName.toLowerCase();
      if (lower.contains('org')) {
        _subjects.clear();
        _subjects.addAll([
          'PERSLIMA',
          'Himapedia',
          'Badan Eksekutif Mahasiswa (BEM)',
          'Dapur Seni Biru',
        ]);
        _selectedSubject = 'PERSLIMA';
      } else if (lower.contains('comm')) {
        _subjects.clear();
        _subjects.addAll([
          'Bandung Book Party',
          'Bandung Bergerak ID',
          'AIESEC',
          'Komunitas Seni',
        ]);
        _selectedSubject = 'Bandung Book Party';
      }
      _initialized = true;
    }
  }

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
        _selectedDate = picked;
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

  void _handleAddCard() {
    final assignmentName = _assignmentController.text.trim();
    if (assignmentName.isEmpty) {
      AppSnackBar.show(
        context,
        message: 'Please insert an assignment name',
        backgroundColor: AppColors.urgentRed,
        icon: Icons.error_outline_rounded,
      );
      return;
    }

    final lower = _categoryName.toLowerCase();
    final categoryColor = lower.contains('org')
        ? const Color(0xFF0D62C3)
        : (lower.contains('comm')
            ? const Color(0xFF1E824C)
            : const Color(0xFF1E1E1E));

    final newTask = CardTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      headerTitle: _categoryName,
      subject: _selectedSubject,
      taskName: assignmentName,
      dueDate: _dateString == 'Select a date' ? '12 September 2026' : _dateString,
      priority: _calculatedPriority,
      backgroundColor: categoryColor,
      description: _descriptionController.text.trim(),
    );

    AppSnackBar.show(
      context,
      message: 'Card "$assignmentName" added successfully!',
      icon: Icons.check_circle_outline_rounded,
    );

    if (widget.onCardAdded != null) {
      widget.onCardAdded!(newTask);
    } else {
      Navigator.pop(context, newTask);
    }
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.pop(context);
    }
  }

  String get _headerTitle {
    String title = _categoryName.trim();
    if (!title.toLowerCase().startsWith('add ')) {
      title = 'Add $title';
    }
    if (!title.toLowerCase().endsWith('card')) {
      title = '$title Card';
    }
    return title;
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
                // Header Bar: Dynamic "< Add [Category] Card"
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 14.0, 24.0, 12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _handleBack,
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
                      Expanded(
                        child: Text(
                          _headerTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
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

                        // 1. Assignment Name
                        CustomTextField(
                          label: 'Assignment Name',
                          hintText: 'Insert assignment',
                          controller: _assignmentController,
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

                        // 3. Description
                        Text(
                          'Description',
                          style: AppTypography.inputLabel.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: AppColors.primaryBlack,
                              width: 1.4,
                            ),
                          ),
                          child: TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
                            style: AppTypography.inputText,
                            decoration: const InputDecoration(
                              hintText: 'Add some detail of this assignment',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                              contentPadding: EdgeInsets.all(16.0),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 4. Deadline
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
                                          style:
                                              AppTypography.inputText.copyWith(
                                            color: _dateString ==
                                                    'Select a date'
                                                ? const Color(0xFF9CA3AF)
                                                : AppColors.textPrimary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
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

                        const SizedBox(height: 22),

                        // 5. Automated Priority Indicator (Static visual display based on deadline)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Priority Level',
                                      style: AppTypography.inputLabel.copyWith(
                                        color: const Color(0xFF6B7280),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Automated based on deadline',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              TaskPriorityBadge(
                                priority: _calculatedPriority,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Primary Action Button: "Add Cards"
                        CustomPrimaryButton(
                          text: 'Add Cards',
                          onPressed: _handleAddCard,
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
