import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/card_delete_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../dashboard/presentation/widgets/add_cards_popover.dart';
import '../../../dashboard/presentation/widgets/bottom_dock_nav_bar.dart';
import '../../models/card_group.dart';
import '../widgets/card_group_delete_modal.dart';
import '../widgets/card_group_overview_card.dart';
import '../widgets/dashed_add_card_button.dart';

/// SCREEN 1 - Your Card Groups (Overview)
/// Derived from PDF Pages 1 & 2:
/// - Header: "Your Card Groups" + Edit/Pencil icon (triggers Delete/Selection Mode)
/// - Dashed "Add Card Group" button -> routes to Screen 2
/// - List of Card Groups: Academic, Organization, Community
/// - Selection Mode with red highlight border & bottom Delete modal
/// - Integrated bottom dock bar with Home & Cards navigation
class CardGroupsOverviewScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  final ValueChanged<CardGroup>? onSelectGroup;
  final List<CardGroup>? initialGroups;

  const CardGroupsOverviewScreen({
    super.key,
    this.onBackToHome,
    this.onSelectGroup,
    this.initialGroups,
  });

  @override
  State<CardGroupsOverviewScreen> createState() =>
      _CardGroupsOverviewScreenState();
}

class _CardGroupsOverviewScreenState extends State<CardGroupsOverviewScreen> {
  late List<CardGroup> _groups;
  bool _isSelectionMode = false;
  final Set<String> _selectedGroupIds = {};
  int _selectedNavIndex = 1;

  @override
  void initState() {
    super.initState();
    _groups = widget.initialGroups != null
        ? List.from(widget.initialGroups!)
        : List.from(CardGroup.sampleGroups);
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedGroupIds.clear();
      } else {
        // Pre-select Academic Card Group to demonstrate PDF Page 2 state
        if (_groups.isNotEmpty) {
          _selectedGroupIds.add(_groups.first.id);
        }
      }
    });
  }

  void _toggleGroupSelection(String id) {
    if (!_isSelectionMode) {
      return;
    }
    setState(() {
      if (_selectedGroupIds.contains(id)) {
        _selectedGroupIds.remove(id);
      } else {
        _selectedGroupIds.add(id);
      }
    });
  }

  void _deleteSelectedGroups() {
    final count = _selectedGroupIds.length;
    setState(() {
      _groups.removeWhere((g) => _selectedGroupIds.contains(g.id));
      _selectedGroupIds.clear();
      _isSelectionMode = false;
    });

    AppSnackBar.show(
      context,
      message: '$count Card Group(s) deleted',
      icon: Icons.delete_outline_rounded,
    );
  }

  void _deleteSingleGroup(String id, String title) {
    setState(() {
      _groups.removeWhere((g) => g.id == id);
      _selectedGroupIds.remove(id);
    });

    AppSnackBar.show(
      context,
      message: 'Card Group "$title" deleted',
      icon: Icons.delete_outline_rounded,
    );
  }

  void _handleGroupTap(CardGroup group) {
    if (_isSelectionMode) {
      _toggleGroupSelection(group.id);
      return;
    }

    if (widget.onSelectGroup != null) {
      widget.onSelectGroup!(group);
    } else {
      Navigator.pushNamed(context, AppRoutes.cardGroupDetail, arguments: group);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    // Header Bar: "Your Card Groups" + Edit/Pencil icon (Selection/Delete mode trigger)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Your Card Groups',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                          Tooltip(
                            message: _isSelectionMode
                                ? 'Exit Selection Mode'
                                : 'Select / Delete Groups',
                            child: GestureDetector(
                              onTap: _toggleSelectionMode,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
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
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable List
                    Expanded(
                      child: _groups.isEmpty
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      24.0, 8.0, 24.0, 0.0),
                                  child: DashedAddCardButton(
                                    title: 'Add Card Group',
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, AppRoutes.addCardGroup);
                                    },
                                  ),
                                ),
                                const Expanded(
                                  child: Center(
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 80.0),
                                        child: EmptyStateWidget(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                  24.0, 8.0, 24.0, 100.0),
                              children: [
                                // Dashed "Add Card Group" Button
                                DashedAddCardButton(
                                  title: 'Add Card Group',
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.addCardGroup);
                                  },
                                ),

                                // Card Groups
                                ..._groups.map((group) {
                                  final isSelected =
                                      _selectedGroupIds.contains(group.id);
                                  return CardGroupOverviewCard(
                                    group: group,
                                    isSelected: isSelected,
                                    isSelectionMode: _isSelectionMode,
                                    onTap: () => _handleGroupTap(group),
                                    onLongPress: () {
                                      if (_isSelectionMode) {
                                        _toggleGroupSelection(group.id);
                                      } else {
                                        CardDeleteConfirmationDialog.show(
                                          context,
                                          cardTitle: group.title,
                                          onConfirm: () =>
                                              _deleteSingleGroup(group.id, group.title),
                                        );
                                      }
                                    },
                                  );
                                }),
                              ],
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
                      AppRoutes.returnToDashboard(context,
                          onBackToHome: widget.onBackToHome);
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

              // Selection Action Modal with smooth slide animation
              if (_isSelectionMode && _selectedGroupIds.isNotEmpty)
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Positioned(
                      bottom: 74.0,
                      left: 0,
                      right: 0,
                      child: Transform.translate(
                        offset: Offset(0, 30.0 * (1.0 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: CardGroupDeleteModal(
                    selectedCount: _selectedGroupIds.length,
                    onDelete: _deleteSelectedGroups,
                    onCancel: () {
                      setState(() {
                        _isSelectionMode = false;
                        _selectedGroupIds.clear();
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
