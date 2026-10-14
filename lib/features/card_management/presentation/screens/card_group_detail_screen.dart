import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/card_delete_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/task_priority_badge.dart';
import '../../../dashboard/presentation/widgets/add_cards_popover.dart';
import '../../../dashboard/presentation/widgets/bottom_dock_nav_bar.dart';
import '../../models/card_group.dart';
import '../widgets/card_group_delete_modal.dart';
import '../widgets/dashed_add_card_button.dart';
import '../../../../core/widgets/task_status_badge.dart';

/// SCREEN 4 - Specific Cards Group View (e.g., Academic Cards Group)
/// Derived from PDF Pages 5 & 6:
/// - Header: "< Academic Cards Group" + Edit/Pencil icon
/// - Dashed "Add Academic Card" button -> routes to Screen 5
/// - List of detailed task cards
/// - Selection mode with red highlight border & bottom Delete modal
/// - Bottom Dock Bar
class CardGroupDetailScreen extends StatefulWidget {
  final CardGroup? group;
  final VoidCallback? onBack;
  final List<CardTask>? initialTasks;

  const CardGroupDetailScreen({
    super.key,
    this.group,
    this.onBack,
    this.initialTasks,
  });

  @override
  State<CardGroupDetailScreen> createState() => _CardGroupDetailScreenState();
}

class _CardGroupDetailScreenState extends State<CardGroupDetailScreen> {
  late List<CardTask> _tasks;
  bool _isSelectionMode = false;
  final Set<String> _selectedTaskIds = {};
  int _selectedNavIndex = 1;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      if (widget.initialTasks != null) {
        _tasks = List.from(widget.initialTasks!);
      } else {
        final group = widget.group ??
            (ModalRoute.of(context)?.settings.arguments as CardGroup?);
        final groupType = group?.groupType ?? 'academic';
        _tasks = List.from(CardTask.getSampleTasksForGroup(groupType));
      }
      _initialized = true;
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedTaskIds.clear();
      } else {
        // Pre-select first card to match PDF Page 6 demonstration
        if (_tasks.isNotEmpty) {
          _selectedTaskIds.add(_tasks.first.id);
        }
      }
    });
  }

  void _toggleTaskSelection(String id) {
    if (!_isSelectionMode) {
      return;
    }
    setState(() {
      if (_selectedTaskIds.contains(id)) {
        _selectedTaskIds.remove(id);
      } else {
        _selectedTaskIds.add(id);
      }
    });
  }

  void _deleteSelectedTasks() {
    final count = _selectedTaskIds.length;
    setState(() {
      _tasks.removeWhere((t) => _selectedTaskIds.contains(t.id));
      _selectedTaskIds.clear();
      _isSelectionMode = false;
    });

    AppSnackBar.show(
      context,
      message: '$count Card(s) deleted',
      icon: Icons.delete_outline_rounded,
    );
  }

  void _deleteSingleTask(String taskId, String taskName) {
    setState(() {
      _tasks.removeWhere((t) => t.id == taskId);
      _selectedTaskIds.remove(taskId);
    });

    AppSnackBar.show(
      context,
      message: 'Card "$taskName" deleted',
      icon: Icons.delete_outline_rounded,
    );
  }

  void _handleTaskStatusChanged(String taskId, String newStatus) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(status: newStatus);
      }
    });
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group ??
        (ModalRoute.of(context)?.settings.arguments as CardGroup?);
    final title = group != null
        ? (group.title.contains('Cards Group')
            ? group.title
            : group.title.replaceAll('Card Group', 'Cards Group'))
        : 'Academic Cards Group';
    final cardTypeLabel = group != null
        ? group.title
            .replaceAll(' Group', '')
            .replaceAll(' Groups', '')
            .replaceAll('Cards', 'Card')
        : 'Academic Card';

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
                    // Header Bar: "< Academic Cards Group" + Edit icon
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 14.0, 24.0, 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: _handleBack,
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
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Edit / Selection Mode Icon with generous touch target
                          Tooltip(
                            message: _isSelectionMode
                                ? 'Exit Selection Mode'
                                : 'Select / Delete Cards',
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

                    // Scrollable Cards List
                    Expanded(
                      child: _tasks.isEmpty
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      24.0, 8.0, 24.0, 0.0),
                                  child: DashedAddCardButton(
                                    title: 'Add $cardTypeLabel',
                                    onTap: () async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        AppRoutes.addCard,
                                        arguments: cardTypeLabel,
                                      );
                                      if (result is CardTask) {
                                        setState(() {
                                          _tasks.add(result);
                                        });
                                      }
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
                                // Dashed "Add [Category] Card" Button
                                DashedAddCardButton(
                                  title: 'Add $cardTypeLabel',
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      AppRoutes.addCard,
                                      arguments: cardTypeLabel,
                                    );
                                    if (result is CardTask) {
                                      setState(() {
                                        _tasks.add(result);
                                      });
                                    }
                                  },
                                ),

                                // Detailed Task Cards
                                ..._tasks.map((task) {
                                  final isSelected =
                                      _selectedTaskIds.contains(task.id);

                                  return _buildTaskCard(task, isSelected);
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
                      AppRoutes.returnToDashboard(context);
                    } else if (index == 1) {
                      Navigator.pop(context);
                    } else if (index == 2) {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.academicSchedule);
                    } else if (index == 3) {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.profile);
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
              if (_isSelectionMode && _selectedTaskIds.isNotEmpty)
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
                    selectedCount: _selectedTaskIds.length,
                    onDelete: _deleteSelectedTasks,
                    onCancel: () {
                      setState(() {
                        _isSelectionMode = false;
                        _selectedTaskIds.clear();
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

  Widget _buildTaskCard(CardTask task, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (_isSelectionMode) {
          _toggleTaskSelection(task.id);
        }
      },
      onLongPress: () {
        if (_isSelectionMode) {
          _toggleTaskSelection(task.id);
        } else {
          CardDeleteConfirmationDialog.show(
            context,
            cardTitle: task.taskName,
            onConfirm: () => _deleteSingleTask(task.id, task.taskName),
          );
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: task.backgroundColor,
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
              blurRadius: isSelected ? 16 : 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Title + Selection Indicator (when active)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.headerTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (_isSelectionMode)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.8,
                      ),
                      color: isSelected
                          ? AppColors.urgentRed
                          : Colors.transparent,
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
            const SizedBox(height: 14),

            // Subject: "Nirmana"
            Text(
              task.subject,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFE4E4E7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),

            // Task Name: "Membuat Nirmana 3D"
            Text(
              task.taskName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Due Date: "Due Date: 12 September 2026"
            Text(
              'Due Date: ${task.dueDate}',
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
                // Interactive Status Dropdown Badge
                TaskStatusBadge(
                  status: task.status,
                  onStatusChanged: (newStatus) {
                    _handleTaskStatusChanged(task.id, newStatus);
                  },
                ),

                // Automated 3-Level Priority Badge (Low, Medium, Urgent) - Static Display
                TaskPriorityBadge(
                  priority: task.priority,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
