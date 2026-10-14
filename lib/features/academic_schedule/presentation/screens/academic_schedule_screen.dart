import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../dashboard/presentation/widgets/add_cards_popover.dart';
import '../../../dashboard/presentation/widgets/bottom_dock_nav_bar.dart';
import '../../models/academic_schedule.dart';
import '../widgets/schedule_day_table_row.dart';
import '../widgets/schedule_reminder_card.dart';

/// SCREEN 1 - Academic Schedule Main View (Root-level Tab)
/// Derived from Updated PDF Page 1:
/// - Navigation Role: Primary root-level tab/view (equivalent to Dashboard & My Cards)
/// - NO back button ('<') on this main schedule view
/// - Header: "Academic Schedule"
/// - Header Action: Edit / Pencil icon button in top right transitioning to Edit Schedule form
/// - Feature Toggle: "Activate Schedule Reminder" (switch button)
/// - Structured schedule table grouped by Days with Subjects and Times
/// - Bottom Dock Navigation Bar with Schedule tab active
/// - NO floating plus button on this main view
class AcademicScheduleScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  final List<DaySchedule>? initialSchedule;

  const AcademicScheduleScreen({
    super.key,
    this.onBackToHome,
    this.initialSchedule,
  });

  @override
  State<AcademicScheduleScreen> createState() => _AcademicScheduleScreenState();
}

class _AcademicScheduleScreenState extends State<AcademicScheduleScreen> {
  bool _isReminderActive = true;
  late List<DaySchedule> _weeklySchedule;

  bool get _isScheduleEmpty =>
      _weeklySchedule.isEmpty ||
      _weeklySchedule.every((d) => d.entries.isEmpty);

  @override
  void initState() {
    super.initState();
    _weeklySchedule = widget.initialSchedule != null
        ? List.from(widget.initialSchedule!)
        : DaySchedule.sampleWeeklySchedule;
  }

  void _openEditSchedule() async {
    final updatedSchedule = await Navigator.pushNamed(
      context,
      AppRoutes.editAcademicSchedule,
      arguments: _weeklySchedule,
    );

    if (updatedSchedule != null && updatedSchedule is List<DaySchedule>) {
      setState(() {
        _weeklySchedule = updatedSchedule;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // As a root tab, pressing system back returns to Dashboard home tab
        if (widget.onBackToHome != null) {
          widget.onBackToHome!();
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
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
                      // Header Bar: "Academic Schedule" + Edit / Pencil Icon
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                'Academic Schedule',
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

                            // Edit / Pencil Icon (top right action)
                            GestureDetector(
                              onTap: _openEditSchedule,
                              behavior: HitTestBehavior.opaque,
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 24,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Scrollable Table Content
                      Expanded(
                        child: _isScheduleEmpty
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
                                padding: const EdgeInsets.fromLTRB(
                                    24.0, 4.0, 24.0, 96.0),
                                children: [
                                  // 1. "Activate Schedule Reminder" Card
                                  ScheduleReminderCard(
                                    isReminderActive: _isReminderActive,
                                    onToggle: (val) {
                                      setState(() {
                                        _isReminderActive = val;
                                      });
                                      AppSnackBar.show(
                                        context,
                                        message: val
                                            ? 'Schedule reminders activated.'
                                            : 'Schedule reminders deactivated.',
                                        icon: val
                                            ? Icons.notifications_active_rounded
                                            : Icons.notifications_off_outlined,
                                        duration: const Duration(seconds: 2),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 24),

                                  // 2. Structured Table Header: "Day", "Subject", "Time"
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 96,
                                          child: Text(
                                            'Day',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            'Subject',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Time',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 8),
                                  const Divider(
                                    height: 1,
                                    thickness: 0.8,
                                    color: Color(0xFFE5E7EB),
                                  ),

                                  // 3. Days Schedule Rows (Monday to Thursday/Friday)
                                  ..._weeklySchedule.map((daySchedule) {
                                    return ScheduleDayTableRow(
                                      daySchedule: daySchedule,
                                      showDivider:
                                          daySchedule != _weeklySchedule.last,
                                    );
                                  }),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),

                // Bottom Dock Navigation Bar (active tab index 2 for Academic Schedule)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomDockNavBar(
                    selectedIndex: 2,
                    onItemSelected: (index) {
                      if (index == 0) {
                        AppRoutes.returnToDashboard(context,
                            onBackToHome: widget.onBackToHome);
                      } else if (index == 1) {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.cardGroups);
                      } else if (index == 3) {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.profile);
                      }
                    },
                    onAddPressed: () => AddCardsPopover.show(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
