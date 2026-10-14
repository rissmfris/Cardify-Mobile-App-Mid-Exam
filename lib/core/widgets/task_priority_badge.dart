import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Card Priority options for Cardify tasks:
/// 1. Low - Soft calm blue
/// 2. Medium - Vibrant warm amber/orange
/// 3. Urgent - High priority bright red
enum CardPriority {
  low('Low'),
  medium('Medium'),
  urgent('Urgent');

  final String label;
  const CardPriority(this.label);

  static CardPriority fromString(String? value) {
    if (value == null) return CardPriority.urgent;
    final clean = value.trim().toLowerCase();
    if (clean == 'low') return CardPriority.low;
    if (clean == 'medium' || clean == 'normal') return CardPriority.medium;
    return CardPriority.urgent;
  }

  Color get backgroundColor {
    switch (this) {
      case CardPriority.low:
        return const Color(0xFF3B82F6); // Soft calm blue
      case CardPriority.medium:
        return const Color(0xFFF59E0B); // Amber / Orange
      case CardPriority.urgent:
        return AppColors.urgentRed; // Vibrant Urgent Red
    }
  }

  Color get foregroundColor => Colors.white;
}

/// Static visual reminder badge component for Task and Card priorities.
/// Displays automated priority states ("Urgent", "Medium", "Low") with clear color-coding:
/// - Low: Soft blue tag (#3B82F6)
/// - Medium: Warm amber/orange tag (#F59E0B)
/// - Urgent: High priority red tag (#EF4444)
///
/// This priority state is an automated frontend indicator reflecting the task's deadline
/// (calculated from mock/initial data or backend service). It is purely static and non-interactive;
/// users cannot click or manually change this priority state.
class TaskPriorityBadge extends StatelessWidget {
  final String priority;

  const TaskPriorityBadge({
    super.key,
    this.priority = 'Urgent',
    // Kept optional for backward compatibility if existing callers pass them, but not interactive
    ValueChanged<String>? onPriorityChanged,
    bool isInteractive = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardPriority = CardPriority.fromString(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
      decoration: BoxDecoration(
        color: cardPriority.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardPriority.backgroundColor.withAlpha(60),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        cardPriority.label,
        style: TextStyle(
          color: cardPriority.foregroundColor,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}
