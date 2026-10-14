import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Clean profile menu row item supporting title, optional subtitle, trailing icon,
/// and destructive styling.
class ProfileMenuTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? trailingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool showDivider;

  const ProfileMenuTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingIcon,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? AppColors.urgentRed : AppColors.textPrimary;
    final iconColor = isDestructive ? AppColors.urgentRed : AppColors.textPrimary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
            child: Row(
              children: [
                // Title and Subtitle Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Trailing Action Widget or Icon
                if (trailing != null)
                  trailing!
                else if (trailingIcon != null)
                  Icon(
                    trailingIcon,
                    size: 20,
                    color: iconColor,
                  ),
              ],
            ),
          ),
        ),

        // Subtle divider between tiles
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 0.8,
            indent: 18,
            endIndent: 18,
            color: Color(0xFFF1F2F4),
          ),
      ],
    );
  }
}
