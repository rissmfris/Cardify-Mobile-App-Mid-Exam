import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/notification_item.dart';

/// Notification item tile with colored timeline indicator, metadata, and selection circle.
class NotificationItemTile extends StatelessWidget {
  final NotificationItem item;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;

  const NotificationItemTile({
    super.key,
    required this.item,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: const Color(0x08000000),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Vertical Colored Bar Indicator
            Container(
              width: 3.5,
              height: item.secondaryDetail != null ? 58.0 : 42.0,
              decoration: BoxDecoration(
                color: item.indicatorColor,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            const SizedBox(width: 14),

            // Middle: Title & Subtitles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Subtitle
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  // Optional Secondary Detail (e.g., due date or time interval)
                  if (item.secondaryDetail != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.secondaryDetail!,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Right side: Metadata or Selection Circle
            if (isSelectionMode)
              // Selection circle radio
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBlack,
                      width: 1.8,
                    ),
                    color: isSelected ? AppColors.primaryBlack : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 13,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              )
            else
              // Normal Mode: Card Type & Time Ago
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.cardTypeLabel,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.timeAgo,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
