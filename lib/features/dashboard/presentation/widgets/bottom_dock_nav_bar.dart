import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import 'add_cards_popover.dart';

/// Bottom Dock Navigation Bar matching the Cardify design with prominent center '+' action.
/// Features expanded touch targets (full-width & full-height hit test areas) for every tab
/// and the center '+' action to guarantee comfortable, error-free tapping.
class BottomDockNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback? onAddPressed;

  const BottomDockNavBar({
    super.key,
    this.selectedIndex = 0,
    required this.onItemSelected,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF0F0F2), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 2, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Home Tab (Solid/Filled when active, Outline when inactive)
          _buildNavButton(
            context: context,
            icon: selectedIndex == 0
                ? Icons.home_rounded
                : Icons.home_outlined,
            isSelected: selectedIndex == 0,
            tooltip: 'Home',
            onTap: () => onItemSelected(0),
          ),

          // 2. Folder / Cards Tab (Solid/Filled rounded square when active, Outline when inactive)
          _buildNavButton(
            context: context,
            icon: selectedIndex == 1
                ? Icons.square_rounded
                : Icons.crop_square_rounded,
            isSelected: selectedIndex == 1,
            tooltip: 'Card Groups',
            onTap: () => onItemSelected(1),
          ),

          // 3. Center '+' Add Button with generous, equalized touch area
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: Tooltip(
                message: 'Add Cards',
                child: InkResponse(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (onAddPressed != null) {
                      onAddPressed!();
                    } else {
                      AddCardsPopover.show(context);
                    }
                  },
                  containedInkWell: false,
                  radius: 30,
                  splashColor: AppColors.primaryBlack.withAlpha(25),
                  highlightColor: AppColors.primaryBlack.withAlpha(12),
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primaryBlack,
                          width: 2.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: AppColors.primaryBlack,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 4. Tasks / Schedule Tab (Solid/Filled when active, Outline when inactive)
          _buildNavButton(
            context: context,
            icon: selectedIndex == 2
                ? Icons.article_rounded
                : Icons.article_outlined,
            isSelected: selectedIndex == 2,
            tooltip: 'Academic Schedule',
            onTap: () => onItemSelected(2),
          ),

          // 5. Profile Tab (Solid/Filled when active, Outline when inactive)
          _buildNavButton(
            context: context,
            icon: selectedIndex == 3
                ? Icons.person_rounded
                : Icons.person_outline_rounded,
            isSelected: selectedIndex == 3,
            tooltip: 'Profile',
            onTap: () => onItemSelected(3),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required bool isSelected,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: Tooltip(
          message: tooltip,
          child: InkResponse(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            containedInkWell: false,
            radius: 28,
            splashColor: AppColors.primaryBlack.withAlpha(20),
            highlightColor: AppColors.primaryBlack.withAlpha(10),
            child: Container(
              height: 52,
              alignment: Alignment.center,
              child: AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                child: Icon(
                  icon,
                  size: 26,
                  color: isSelected
                      ? AppColors.primaryBlack
                      : const Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
