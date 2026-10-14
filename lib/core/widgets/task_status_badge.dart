import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Task Status options matching Cardify's design system:
/// 1. Not Started - Neutral cool gray
/// 2. On Progress - Active vibrant yellow/amber
/// 3. Done - Crisp emerald green
enum TaskStatus {
  notStarted('Not Started'),
  onProgress('On Progress'),
  done('Done');

  final String label;
  const TaskStatus(this.label);

  static TaskStatus fromString(String? value) {
    if (value == null) return TaskStatus.onProgress;
    final clean = value.trim().toLowerCase();
    if (clean == 'not started' || clean == 'notstarted') {
      return TaskStatus.notStarted;
    }
    if (clean == 'done' ||
        clean == 'completed' ||
        clean == 'finish' ||
        clean == 'finished') {
      return TaskStatus.done;
    }
    return TaskStatus.onProgress;
  }

  Color get backgroundColor {
    switch (this) {
      case TaskStatus.notStarted:
        return const Color(0xFF6B7280); // Neutral slate/zinc gray
      case TaskStatus.onProgress:
        return AppColors.progressYellow; // Active yellow/amber
      case TaskStatus.done:
        return AppColors.successGreen; // Crisp emerald green
    }
  }

  Color get foregroundColor {
    switch (this) {
      case TaskStatus.notStarted:
        return Colors.white;
      case TaskStatus.onProgress:
        return AppColors.primaryBlack;
      case TaskStatus.done:
        return Colors.white;
    }
  }
}

/// Interactive pill badge component for Task and Card statuses.
/// Displays the current status and triggers an interactive popup menu
/// with the three specified statuses when tapped.
class TaskStatusBadge extends StatefulWidget {
  final String status;
  final ValueChanged<String>? onStatusChanged;
  final bool isInteractive;

  const TaskStatusBadge({
    super.key,
    this.status = 'On Progress',
    this.onStatusChanged,
    this.isInteractive = true,
  });

  @override
  State<TaskStatusBadge> createState() => _TaskStatusBadgeState();
}

class _TaskStatusBadgeState extends State<TaskStatusBadge> {
  late TaskStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = TaskStatus.fromString(widget.status);
  }

  @override
  void didUpdateWidget(covariant TaskStatusBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status) {
      _currentStatus = TaskStatus.fromString(widget.status);
    }
  }

  void _selectStatus(TaskStatus newStatus) {
    if (_currentStatus == newStatus) return;
    setState(() {
      _currentStatus = newStatus;
    });
    widget.onStatusChanged?.call(newStatus.label);
  }

  Widget _buildBadgePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _currentStatus.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _currentStatus.label,
            style: TextStyle(
              color: _currentStatus.foregroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
            ),
          ),
          if (widget.isInteractive) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: _currentStatus.foregroundColor,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isInteractive) {
      return _buildBadgePill();
    }

    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: const Color(0xFF27272A),
          surfaceTintColor: Colors.transparent,
          elevation: 10,
          shadowColor: const Color(0x66000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFF3F3F46), width: 1.0),
          ),
        ),
      ),
      child: PopupMenuButton<TaskStatus>(
        initialValue: _currentStatus,
        tooltip: 'Change Status',
        offset: const Offset(0, 36),
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(20),
        onSelected: _selectStatus,
        itemBuilder: (BuildContext context) {
          return TaskStatus.values.map((status) {
            final isSelected = status == _currentStatus;
            return PopupMenuItem<TaskStatus>(
              value: status,
              height: 44,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: status.backgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: status.backgroundColor.withAlpha(128),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: status.backgroundColor == AppColors.progressYellow
                          ? const Color(0xFFFBBF24)
                          : status.backgroundColor,
                    ),
                ],
              ),
            );
          }).toList();
        },
        child: _buildBadgePill(),
      ),
    );
  }
}
