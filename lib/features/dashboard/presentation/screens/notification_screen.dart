import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../models/card_item.dart';
import '../../models/notification_item.dart';
import '../widgets/add_cards_popover.dart';
import '../widgets/bottom_dock_nav_bar.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/delete_selection_modal.dart';
import '../widgets/notification_item_tile.dart';

/// SCREEN 2 - Notification Screen (Timeline & List & Interactive Selection Mode)
/// Derived from PDF Pages 2 & 3:
/// - Header: Back arrow "<", "Notification", Edit/Pencil icon
/// - Category Filter Chips: "All", "Academic", "Organization", "PKM"
/// - Sections grouped by: "Today", "Yesterday", "Wednesday"
/// - Selection Mode with radio check circles and Bottom Action Sheet ("3 Items Selected", "Delete Notification?", "Cancel")
class NotificationScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final List<NotificationItem>? initialNotifications;

  const NotificationScreen({
    super.key,
    this.onBack,
    this.initialNotifications,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  CardCategory _selectedCategory = CardCategory.all;
  bool _isSelectionMode = false;
  final Set<String> _selectedItemIds = {};
  final int _selectedNavIndex = 0;

  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = widget.initialNotifications != null
        ? List.from(widget.initialNotifications!)
        : List.from(NotificationItem.sampleNotifications);
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItemIds.clear();
      } else {
        // Pre-select 3 items to match PDF Page 3 initial demonstration
        if (_notifications.length >= 4) {
          _selectedItemIds.add(_notifications[1].id); // Nirmana
          _selectedItemIds.add(_notifications[2].id); // Rapat Bidang
          _selectedItemIds.add(_notifications[3].id); // Asset Sosmed
        }
      }
    });
  }

  void _toggleItemSelection(String id) {
    if (!_isSelectionMode) {
      _toggleSelectionMode();
      return;
    }
    setState(() {
      if (_selectedItemIds.contains(id)) {
        _selectedItemIds.remove(id);
      } else {
        _selectedItemIds.add(id);
      }
    });
  }

  void _deleteSelectedItems() {
    final count = _selectedItemIds.length;
    setState(() {
      _notifications.removeWhere((item) => _selectedItemIds.contains(item.id));
      _selectedItemIds.clear();
      _isSelectionMode = false;
    });

    AppSnackBar.show(
      context,
      message: '$count Notification(s) deleted',
      icon: Icons.delete_outline_rounded,
    );
  }

  List<NotificationItem> get _filteredNotifications {
    if (_selectedCategory == CardCategory.all) {
      return _notifications;
    }
    return _notifications
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotifications;
    final sections = ['Today', 'Yesterday', 'Wednesday'];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Stack(
            children: [
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Bar: "< Notification" + Edit icon
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 14.0, 24.0, 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (widget.onBack != null) {
                                    widget.onBack!();
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 4.0),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 20,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Notification',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),

                          // Edit / Selection Mode Icon
                          GestureDetector(
                            onTap: _toggleSelectionMode,
                            behavior: HitTestBehavior.opaque,
                            child: Icon(
                              _isSelectionMode
                                  ? Icons.check_circle_rounded
                                  : Icons.edit_outlined,
                              size: 22,
                              color: _isSelectionMode
                                  ? AppColors.primaryBlack
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Filter Chips: "All", "Academic", "Organization", "PKM"
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: CategoryTabBar(
                        selectedCategory: _selectedCategory,
                        categories: const [
                          CardCategory.all,
                          CardCategory.academic,
                          CardCategory.organization,
                          CardCategory.pkm,
                        ],
                        onCategorySelected: (cat) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Grouped Notification Timeline List
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 80.0),
                                  child: EmptyStateWidget(),
                                ),
                              ),
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 110.0),
                              children: sections.map((sectionName) {
                                final sectionItems = filtered
                                    .where((item) => item.sectionGroup == sectionName)
                                    .toList();

                                if (sectionItems.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Section Title (e.g. "Today", "Yesterday", "Wednesday")
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          24.0, 16.0, 24.0, 8.0),
                                      child: Text(
                                        sectionName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),

                                    // Items in this section
                                    ...sectionItems.map((item) {
                                      return NotificationItemTile(
                                        item: item,
                                        isSelectionMode: _isSelectionMode,
                                        isSelected:
                                            _selectedItemIds.contains(item.id),
                                        onTap: () => _toggleItemSelection(item.id),
                                      );
                                    }),
                                  ],
                                );
                              }).toList(),
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
                    if (index == 0) {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.pop(context);
                      }
                    } else if (index == 1) {
                      Navigator.pushReplacementNamed(context, AppRoutes.cardGroups);
                    } else if (index == 2) {
                      Navigator.pushReplacementNamed(context, AppRoutes.academicSchedule);
                    } else if (index == 3) {
                      Navigator.pushReplacementNamed(context, AppRoutes.profile);
                    }
                  },
                  onAddPressed: () => AddCardsPopover.show(context),
                ),
              ),

              // Selection Action Modal (PDF Page 3)
              if (_isSelectionMode && _selectedItemIds.isNotEmpty)
                Positioned(
                  bottom: 74.0,
                  left: 0,
                  right: 0,
                  child: DeleteSelectionModal(
                    selectedCount: _selectedItemIds.length,
                    onDelete: _deleteSelectedItems,
                    onCancel: () {
                      setState(() {
                        _isSelectionMode = false;
                        _selectedItemIds.clear();
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
