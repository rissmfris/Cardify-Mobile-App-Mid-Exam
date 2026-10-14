import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/task_priority_badge.dart';
import '../../../../core/widgets/task_status_badge.dart';

/// Interactive preview card for "Academic Card" in Screen 3.
/// Features dynamic interactive status dropdown menu with Not Started, On Progress, and Done,
/// and interactive 3-level priority badge (Low, Medium, Urgent).
class AcademicCardPreview extends StatefulWidget {
  final String initialStatus;
  final ValueChanged<String>? onStatusChanged;

  const AcademicCardPreview({
    super.key,
    this.initialStatus = 'On Progress',
    this.onStatusChanged,
  });

  @override
  State<AcademicCardPreview> createState() => _AcademicCardPreviewState();
}

class _AcademicCardPreviewState extends State<AcademicCardPreview> {
  late String _currentStatus;
  String _currentPriority = 'Urgent';

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
  }

  @override
  void didUpdateWidget(covariant AcademicCardPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialStatus != oldWidget.initialStatus) {
      _currentStatus = widget.initialStatus;
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Academic Card
          Text(
            'Academic Card',
            style: AppTypography.cardTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          // Divider
          const Divider(
            color: Color(0xFF3F3F46),
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 16),
          // Subject
          Text(
            'Nirmana',
            style: AppTypography.bodyOnDark.copyWith(
              fontSize: 14,
              color: const Color(0xFFD4D4D8),
            ),
          ),
          const SizedBox(height: 6),
          // Task Name
          Text(
            'Membuat Nirmana 3D',
            style: AppTypography.cardTitle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          // Due Date
          Text(
            'Due Date: 12 September 2026',
            style: AppTypography.bodyOnDark.copyWith(
              fontSize: 13,
              color: const Color(0xFFA1A1AA),
            ),
          ),
          const SizedBox(height: 16),
          // Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Interactive Status Dropdown Badge
              TaskStatusBadge(
                status: _currentStatus,
                onStatusChanged: _handleStatusChanged,
              ),
              // Interactive Priority Badge (Low, Medium, Urgent)
              TaskPriorityBadge(
                priority: _currentPriority,
                onPriorityChanged: (newPriority) {
                  setState(() {
                    _currentPriority = newPriority;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Interactive preview card for "Academic Card Group" in Screen 3.
class AcademicGroupPreview extends StatelessWidget {
  const AcademicGroupPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Academic Card Group
          Text(
            'Academic Card Group',
            style: AppTypography.cardTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          // Divider
          const Divider(
            color: Color(0xFF3F3F46),
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 16),
          // Items
          _buildItem('Nirmana'),
          const SizedBox(height: 12),
          _buildItem('Teknologi Imersif'),
          const SizedBox(height: 12),
          _buildItem('Pemrograman Berorientasi Objek'),
        ],
      ),
    );
  }

  Widget _buildItem(String title) {
    return Text(
      title,
      style: AppTypography.bodyOnDark.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}
