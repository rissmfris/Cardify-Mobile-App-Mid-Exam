import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Mutable helper representation for each subject-time row in the form.
class FormSubjectItem {
  final TextEditingController subjectController;
  final TextEditingController timeController;

  FormSubjectItem({
    required String subject,
    required String time,
  })  : subjectController = TextEditingController(text: subject),
        timeController = TextEditingController(text: time);

  void dispose() {
    subjectController.dispose();
    timeController.dispose();
  }
}

/// A day section block in the Add/Edit Academic Schedule Form.
/// Directly derived from Screen 2 in the design PDF.
class ScheduleDayFormBlock extends StatelessWidget {
  final String dayName;
  final List<FormSubjectItem> items;
  final VoidCallback onAddSubject;
  final ValueChanged<int> onRemoveSubject;

  const ScheduleDayFormBlock({
    super.key,
    required this.dayName,
    required this.items,
    required this.onAddSubject,
    required this.onRemoveSubject,
  });

  Future<void> _pickTimeRange(
      BuildContext context, FormSubjectItem item) async {
    final text = item.timeController.text.trim();
    final parts = text.contains('-') ? text.split('-') : <String>[];

    final initialStart = parts.isNotEmpty
        ? _parseTime(parts[0], const TimeOfDay(hour: 9, minute: 0))
        : const TimeOfDay(hour: 9, minute: 0);

    final initialEnd = parts.length > 1
        ? _parseTime(parts[1],
            TimeOfDay(hour: (initialStart.hour + 2) % 24, minute: initialStart.minute))
        : TimeOfDay(
            hour: (initialStart.hour + 2) % 24, minute: initialStart.minute);

    final pickedStart = await showTimePicker(
      context: context,
      initialTime: initialStart,
      helpText: 'Select Start Time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlack,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (pickedStart == null || !context.mounted) return;

    final pickedEnd = await showTimePicker(
      context: context,
      initialTime: initialEnd,
      helpText: 'Select End Time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlack,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (pickedEnd == null || !context.mounted) return;

    final sH = pickedStart.hour.toString().padLeft(2, '0');
    final sM = pickedStart.minute.toString().padLeft(2, '0');
    final eH = pickedEnd.hour.toString().padLeft(2, '0');
    final eM = pickedEnd.minute.toString().padLeft(2, '0');

    item.timeController.text = '$sH.$sM - $eH.$eM';
  }

  TimeOfDay _parseTime(String timeStr, TimeOfDay fallback) {
    try {
      final clean = timeStr.trim().replaceAll(':', '.');
      final parts = clean.split('.');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null &&
            minute != null &&
            hour >= 0 &&
            hour < 24 &&
            minute >= 0 &&
            minute < 60) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    } catch (_) {}
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Day" Label
        const Text(
          'Day',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),

        // Day Name Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.0,
            ),
          ),
          child: Text(
            dayName,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Headers row: "Subject" & "Time"
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  'Subject',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 146,
                child: Text(
                  'Time',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              SizedBox(width: 50), // Gap corresponding to delete button (42 + 8)
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Subject / Time Input Rows
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No subjects scheduled yet for $dayName.',
              style: const TextStyle(
                fontSize: 13.0,
                color: Color(0xFF9CA3AF),
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Subject TextField (Single clean OutlineInputBorder, no redundant container border)
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 48,
                      child: TextFormField(
                        controller: item.subjectController,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Insert Subject',
                          hintStyle: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 14.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBlack,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBlack,
                              width: 1.8,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: AppColors.urgentRed,
                              width: 1.2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: AppColors.urgentRed,
                              width: 1.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 2. Time Range Picker / Display (Clock prefix, single clean OutlineInputBorder, interactive picker)
                  SizedBox(
                    width: 146,
                    height: 48,
                    child: TextFormField(
                      controller: item.timeController,
                      keyboardType: TextInputType.datetime,
                      onTap: () {
                        if (item.timeController.text.trim().isEmpty) {
                          _pickTimeRange(context, item);
                        }
                      },
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                      decoration: InputDecoration(
                        hintText: '00:00 - 00:00',
                        hintStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 14.0,
                        ),
                        prefixIcon: GestureDetector(
                          onTap: () => _pickTimeRange(context, item),
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 6.0),
                            child: Icon(
                              Icons.access_time_rounded,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 34,
                          minHeight: 48,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlack,
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlack,
                            width: 1.8,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: AppColors.urgentRed,
                            width: 1.2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: AppColors.urgentRed,
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 3. Delete (-) Red Button (Height 48, Radius 12 aligned with inputs)
                  SizedBox(
                    width: 42,
                    height: 48,
                    child: Material(
                      color: AppColors.deleteButtonRed,
                      borderRadius: BorderRadius.circular(12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: () => onRemoveSubject(index),
                        child: const Center(
                          child: Icon(
                            Icons.remove_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 6),

        // "+ Add Subject" Button
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: onAddSubject,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlack,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
            child: const Text(
              '+ Add Subject',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
