import 'package:flutter/material.dart';
import '../../../../core/widgets/task_priority_badge.dart';
import '../../../../core/widgets/task_status_badge.dart';
import '../../models/card_item.dart';

/// Clean reusable content card widget representing Academic, Organization, and Community cards.
/// Supports interactive status dropdown menu and 3-level priority indicator (Low, Medium, Urgent).
/// Supports hold / long-press gesture for delete confirmation.
class DashboardCardWidget extends StatefulWidget {
  final CardItem card;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ValueChanged<String>? onStatusChanged;
  final ValueChanged<String>? onPriorityChanged;

  const DashboardCardWidget({
    super.key,
    required this.card,
    this.onTap,
    this.onLongPress,
    this.onStatusChanged,
    this.onPriorityChanged,
  });

  @override
  State<DashboardCardWidget> createState() => _DashboardCardWidgetState();
}

class _DashboardCardWidgetState extends State<DashboardCardWidget> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.card.status;
  }

  @override
  void didUpdateWidget(covariant DashboardCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.status != oldWidget.card.status) {
      _currentStatus = widget.card.status;
    }
  }

  void _handleStatusChanged(String newStatus) {
    setState(() {
      _currentStatus = newStatus;
    });
    widget.onStatusChanged?.call(newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: widget.card.backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title (e.g., "Academic Card", "Organization Card")
            Text(
              widget.card.headerTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 12),

            // Thin Divider
            Divider(
              color: Colors.white.withAlpha(51), // 20% opacity
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 14),

            // Subtitle / Group / Subject
            Text(
              widget.card.subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFE4E4E7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),

            // Task Name
            Text(
              widget.card.taskName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Due Date
            Text(
              'Due Date: ${widget.card.dueDate}',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFD4D4D8),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),

            // Badges Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Interactive Status Badge Dropdown
                TaskStatusBadge(
                  status: _currentStatus,
                  onStatusChanged: _handleStatusChanged,
                ),

                // Automated 3-Level Priority Badge (Low, Medium, Urgent) - Static Display
                TaskPriorityBadge(
                  priority: widget.card.priority,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
