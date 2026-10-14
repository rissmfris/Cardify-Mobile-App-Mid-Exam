import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/card_item.dart';

/// Clean horizontal category filter tab bar matching the Cardify design.
class CategoryTabBar extends StatelessWidget {
  final CardCategory selectedCategory;
  final ValueChanged<CardCategory> onCategorySelected;
  final List<CardCategory> categories;

  const CategoryTabBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.categories = const [
      CardCategory.all,
      CardCategory.academic,
      CardCategory.organization,
      CardCategory.community,
    ],
  });

  String _getCategoryTitle(CardCategory cat) {
    switch (cat) {
      case CardCategory.all:
        return 'All';
      case CardCategory.academic:
        return 'Academic';
      case CardCategory.organization:
        return 'Organization';
      case CardCategory.community:
        return 'Community';
      case CardCategory.pkm:
        return 'PKM';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final bool isSelected = cat == selectedCategory;
          final title = _getCategoryTitle(cat);

          return GestureDetector(
            onTap: () => onCategorySelected(cat),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.textPrimary
                        : const Color(0xFF9CA3AF),
                    letterSpacing: -0.2,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 14,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlack,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 6.5),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
