import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/smooth_switch_toggle.dart';

/// Clean card container with a toggle for "Activate Schedule Reminder".
/// Derived from Screen 1 (Academic Schedule Overview) design.
class ScheduleReminderCard extends StatelessWidget {
  final bool isReminderActive;
  final ValueChanged<bool> onToggle;

  const ScheduleReminderCard({
    super.key,
    required this.isReminderActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Activate Schedule Reminder',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SmoothSwitchToggle(
            value: isReminderActive,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
