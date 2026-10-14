import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../models/academic_schedule.dart';
import '../widgets/schedule_day_form_block.dart';

/// Internal state helper to manage form controllers for each day.
class _DayFormState {
  final String dayName;
  final List<FormSubjectItem> items;

  _DayFormState({
    required this.dayName,
    required this.items,
  });

  void dispose() {
    for (final item in items) {
      item.dispose();
    }
  }
}

/// SCREEN 2 - Add / Edit Academic Schedule Form
/// Derived from PDF Page 2:
/// - Header: "< Academic Schedule"
/// - Dynamic day blocks with:
///   * Day container (Monday, Tuesday, Wednesday, Thursday, Friday)
///   * Subject input ("Insert Subject") & Time input ("00:00 - 00:00")
///   * Red minus button to delete subject row
///   * "+ Add Subject" button per day
/// - Sticky bottom "Save Schedule" button
class EditAcademicScheduleScreen extends StatefulWidget {
  final List<DaySchedule>? initialSchedule;
  final VoidCallback? onSaved;
  final VoidCallback? onCancelled;

  const EditAcademicScheduleScreen({
    super.key,
    this.initialSchedule,
    this.onSaved,
    this.onCancelled,
  });

  @override
  State<EditAcademicScheduleScreen> createState() =>
      _EditAcademicScheduleScreenState();
}

class _EditAcademicScheduleScreenState
    extends State<EditAcademicScheduleScreen> {
  final List<_DayFormState> _dayForms = [];

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    final schedule = widget.initialSchedule ?? DaySchedule.sampleWeeklySchedule;

    for (final day in schedule) {
      final items = day.entries.map((entry) {
        return FormSubjectItem(
          subject: entry.subject,
          time: entry.time,
        );
      }).toList();

      // If a day has no items, start with one empty item (as shown in PDF Page 2)
      if (items.isEmpty) {
        items.add(FormSubjectItem(subject: '', time: ''));
      }

      _dayForms.add(_DayFormState(
        dayName: day.dayName,
        items: items,
      ));
    }
  }

  @override
  void dispose() {
    for (final form in _dayForms) {
      form.dispose();
    }
    super.dispose();
  }

  void _addSubject(int dayIndex) {
    setState(() {
      _dayForms[dayIndex].items.add(
            FormSubjectItem(subject: '', time: ''),
          );
    });
  }

  void _removeSubject(int dayIndex, int itemIndex) {
    setState(() {
      final removed = _dayForms[dayIndex].items.removeAt(itemIndex);
      removed.dispose();
    });
  }

  void _handleSave() {
    // Convert form items back to DaySchedule list
    final List<DaySchedule> updatedSchedule = [];

    for (final day in _dayForms) {
      final List<ScheduleEntry> validEntries = [];
      for (int i = 0; i < day.items.length; i++) {
        final sub = day.items[i].subjectController.text.trim();
        final tim = day.items[i].timeController.text.trim();

        if (sub.isNotEmpty) {
          validEntries.add(
            ScheduleEntry(
              id: '${day.dayName.toLowerCase()}-$i-${DateTime.now().millisecondsSinceEpoch}',
              subject: sub,
              time: tim.isNotEmpty ? tim : '00:00 - 00:00',
            ),
          );
        }
      }

      updatedSchedule.add(DaySchedule(
        dayName: day.dayName,
        entries: validEntries,
      ));
    }

    AppSnackBar.show(
      context,
      message: 'Academic schedule saved successfully!',
      icon: Icons.check_circle_outline_rounded,
    );

    if (widget.onSaved != null) {
      widget.onSaved!();
    } else {
      Navigator.pop(context, updatedSchedule);
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
                // Header Bar: "< Academic Schedule"
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
                          'Academic Schedule',
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

                // Scrollable Form Days List
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 100.0),
                    itemCount: _dayForms.length,
                    itemBuilder: (context, index) {
                      final dayForm = _dayForms[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: ScheduleDayFormBlock(
                          dayName: dayForm.dayName,
                          items: dayForm.items,
                          onAddSubject: () => _addSubject(index),
                          onRemoveSubject: (itemIdx) =>
                              _removeSubject(index, itemIdx),
                        ),
                      );
                    },
                  ),
                ),

                // Sticky Bottom "Save Schedule" Action Button
                Container(
                  padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 20.0),
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundLight,
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(
                        Icons.bookmark_outline_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Save Schedule',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlack,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
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
