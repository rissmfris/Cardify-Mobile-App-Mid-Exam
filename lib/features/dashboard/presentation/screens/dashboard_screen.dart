import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/card_delete_dialog.dart';
import '../../../card_management/models/card_group.dart';
import '../../models/card_item.dart';
import '../widgets/add_cards_popover.dart';
import '../widgets/bottom_dock_nav_bar.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/dashboard_card_widget.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/empty_state_widget.dart';

/// SCREEN 1 - Main Dashboard (Home Screen)
/// Derived from PDF Pages 1 & 4:
/// - Header Greeting: "Welcome, Eky" + Notification icon
/// - Category Filter Chips: "All", "Academic", "Organization", "Community"
/// - Content Cards: Academic Card (Dark), Organization Card (Blue), Community Card (Green)
/// - Bottom Dock with 5 items and '+' Add button
/// - Tapping '+' displays SCREEN 3: Add Cards Popover Menu
class DashboardScreen extends StatefulWidget {
  final VoidCallback? onOpenNotifications;
  final List<CardItem>? initialCards;

  const DashboardScreen({
    super.key,
    this.onOpenNotifications,
    this.initialCards,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CardCategory _selectedCategory = CardCategory.all;
  int _selectedNavIndex = 0;

  late final List<CardItem> _cards;

  @override
  void initState() {
    super.initState();
    _cards = widget.initialCards != null
        ? List.from(widget.initialCards!)
        : List.from(CardItem.sampleCards);
  }

  List<CardItem> get _filteredCards {
    if (_selectedCategory == CardCategory.all) {
      return _cards;
    }
    return _cards.where((card) => card.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Prevent accidental loop back to auth or onboarding screens
        if (didPop) return;
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Stack(
            children: [
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Top App Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Header Greeting: "Welcome, Eky"
                          const Expanded(
                            child: Text(
                              'Welcome, Eky',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          Row(
                            children: [
                              // Academic Schedule shortcut icon
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.academicSchedule);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 4.0),
                                  child: Icon(
                                    Icons.calendar_month_outlined,
                                    size: 26,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Notification Bell with unread dot
                              GestureDetector(
                                onTap: () {
                                  if (widget.onOpenNotifications != null) {
                                    widget.onOpenNotifications!();
                                  } else {
                                    Navigator.pushNamed(
                                        context, AppRoutes.notifications);
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    const Icon(
                                      Icons.notifications_none_rounded,
                                      size: 28,
                                      color: AppColors.textPrimary,
                                    ),
                                    Positioned(
                                      top: 1,
                                      right: 2,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.urgentRed,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Category Filter Chips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: CategoryTabBar(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (cat) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Academic Schedule Quick Link Banner
                    if (_selectedCategory == CardCategory.academic)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 10.0),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.academicSchedule),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                                width: 1.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 18,
                                  color: AppColors.primaryBlack,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'View Academic Schedule',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Scrollable Cards List
                    Expanded(
                      child: _filteredCards.isEmpty
                          ? const Center(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 80.0),
                                  child: EmptyStateWidget(),
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                  24.0, 8.0, 24.0, 100.0),
                              itemCount: _filteredCards.length,
                              itemBuilder: (context, index) {
                          final card = _filteredCards[index];
                          return DashboardCardWidget(
                            card: card,
                            onTap: () {
                              final group = CardGroup.sampleGroups.firstWhere(
                                (g) => g.groupType == card.category.name,
                                orElse: () => CardGroup(
                                  id: card.id,
                                  title: card.headerTitle.endsWith('Group')
                                      ? card.headerTitle
                                      : '${card.headerTitle} Group',
                                  groupType: card.category.name,
                                  backgroundColor: card.backgroundColor,
                                  items: [card.subtitle],
                                ),
                              );
                              Navigator.pushNamed(
                                context,
                                AppRoutes.cardGroupDetail,
                                arguments: group,
                              );
                            },
                            onStatusChanged: (newStatus) {
                              setState(() {
                                final idx = _cards.indexWhere((c) => c.id == card.id);
                                if (idx != -1) {
                                  _cards[idx] = _cards[idx].copyWith(status: newStatus);
                                }
                              });
                            },
                            onLongPress: () {
                              CardDeleteConfirmationDialog.show(
                                context,
                                cardTitle: card.taskName,
                                onConfirm: () {
                                  setState(() {
                                    _cards.removeWhere((c) => c.id == card.id);
                                  });
                                  AppSnackBar.show(
                                    context,
                                    message: 'Card "${card.taskName}" deleted',
                                    icon: Icons.delete_outline_rounded,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Dock Nav Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BottomDockNavBar(
                  selectedIndex: _selectedNavIndex,
                  onItemSelected: (index) {
                    if (index == 1) {
                      Navigator.pushNamed(context, AppRoutes.cardGroups);
                    } else if (index == 2) {
                      Navigator.pushNamed(context, AppRoutes.academicSchedule);
                    } else if (index == 3) {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    } else {
                      setState(() {
                        _selectedNavIndex = index;
                      });
                    }
                  },
                  onAddPressed: () => AddCardsPopover.show(context),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
