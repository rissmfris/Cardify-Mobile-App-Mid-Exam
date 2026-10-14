import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/card_group.dart';

/// Card widget for "Your Card Groups" overview (PDF Pages 1 & 2).
class CardGroupOverviewCard extends StatelessWidget {
  final CardGroup group;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const CardGroupOverviewCard({
    super.key,
    required this.group,
    this.isSelected = false,
    this.isSelectionMode = false,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: group.backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected
              ? Border.all(
                  color: AppColors.urgentRed,
                  width: 2.2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x33EB4D4B)
                  : const Color(0x1A000000),
              blurRadius: isSelected ? 16 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Group Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    group.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (isSelectionMode)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.8,
                      ),
                      color: isSelected ? AppColors.urgentRed : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Thin Divider
            Divider(
              color: Colors.white.withAlpha(51),
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 16),

            // Items List
            ...group.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
