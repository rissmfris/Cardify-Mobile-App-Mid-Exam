import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/academic_schedule.dart';

/// Formats a single day's structured schedule row in the Academic Schedule table.
/// Directly derived from Screen 1 (Academic Schedule Overview) in the design PDF.
class ScheduleDayTableRow extends StatelessWidget {
  final DaySchedule daySchedule;
  final bool showDivider;

  const ScheduleDayTableRow({
    super.key,
    required this.daySchedule,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    if (daySchedule.entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Day Column
              SizedBox(
                width: 96,
                child: Text(
                  daySchedule.dayName,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),

              // 2. Subject Column
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: daySchedule.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        entry.subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(width: 8),

              // 3. Time Column
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: daySchedule.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        entry.time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF374151),
                          letterSpacing: -0.2,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Subtle divider separating days
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 0.8,
            color: Color(0xFFEEEEF0),
          ),
      ],
    );
  }
}
