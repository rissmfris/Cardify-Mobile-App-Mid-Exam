import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cardify_mobile/core/widgets/empty_state_widget.dart';
import 'package:cardify_mobile/features/academic_schedule/models/academic_schedule.dart';
import 'package:cardify_mobile/features/academic_schedule/presentation/screens/academic_schedule_screen.dart';
import 'package:cardify_mobile/features/card_management/models/card_group.dart';
import 'package:cardify_mobile/features/card_management/presentation/screens/card_group_detail_screen.dart';
import 'package:cardify_mobile/features/card_management/presentation/screens/card_groups_overview_screen.dart';
import 'package:cardify_mobile/features/dashboard/models/card_item.dart';
import 'package:cardify_mobile/features/dashboard/models/notification_item.dart';
import 'package:cardify_mobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:cardify_mobile/features/dashboard/presentation/screens/notification_screen.dart';

void main() {
  const emptyStateText = "There's nothing to see here,\nadd some cards.";

  group('1. Reusable Empty State Component Tests', () {
    testWidgets('EmptyStateWidget renders sad folder icon and default message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check sad folder icon
      expect(find.byType(SadFolderIcon), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      // Check default message
      expect(find.text(emptyStateText), findsOneWidget);
    });

    testWidgets('EmptyStateWidget renders custom message and action button when provided',
        (WidgetTester tester) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              message: 'Custom empty message',
              actionLabel: 'Click Me',
              onAction: () => actionTapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom empty message'), findsOneWidget);
      expect(find.text('Click Me'), findsOneWidget);

      await tester.tap(find.text('Click Me'));
      await tester.pumpAndSettle();

      expect(actionTapped, isTrue);
    });
  });

  group('2. Contextual Screen Empty State Tests', () {
    testWidgets('DashboardScreen renders EmptyStateWidget when cards are empty',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Empty cards list
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(initialCards: []),
        ),
      );
      await tester.pumpAndSettle();

      // Should display EmptyStateWidget
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(emptyStateText), findsOneWidget);
    });

    testWidgets(
        'DashboardScreen switches to EmptyStateWidget when filtering to category with no cards',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Only Academic card
      final List<CardItem> academicOnly = [
        const CardItem(
          id: 'test-1',
          headerTitle: 'Academic',
          subtitle: 'Desain dan Pemrograman Website',
          taskName: 'Nirmana 3 Dimensi',
          dueDate: '12 May 2024',
          category: CardCategory.academic,
          backgroundColor: Color(0xFF1E1E1E),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(initialCards: academicOnly),
        ),
      );
      await tester.pumpAndSettle();

      // Initially All category shows Academic Card
      expect(find.text('Nirmana 3 Dimensi'), findsOneWidget);
      expect(find.byType(EmptyStateWidget), findsNothing);

      // Select 'Organization' category which has 0 cards
      await tester.tap(find.text('Organization'));
      await tester.pumpAndSettle();

      // Should now show EmptyStateWidget
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(emptyStateText), findsOneWidget);
      expect(find.text('Nirmana 3 Dimensi'), findsNothing);

      // Switch back to 'Academic' category
      await tester.tap(find.text('Academic'));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsNothing);
      expect(find.text('Nirmana 3 Dimensi'), findsOneWidget);
    });

    testWidgets('CardGroupsOverviewScreen renders EmptyStateWidget when groups are empty',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: CardGroupsOverviewScreen(initialGroups: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(emptyStateText), findsOneWidget);
      // "Add Card Group" button remains accessible at the top
      expect(find.text('Add Card Group'), findsOneWidget);
    });

    testWidgets('CardGroupDetailScreen renders EmptyStateWidget when tasks are empty',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final group = CardGroup(
        id: 'academic',
        title: 'Academic Cards Group',
        groupType: 'academic',
        backgroundColor: const Color(0xFF1E1E1E),
        items: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CardGroupDetailScreen(
            group: group,
            initialTasks: const [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(emptyStateText), findsOneWidget);
      expect(find.text('Add Academic Card'), findsOneWidget);
    });

    testWidgets('NotificationScreen renders EmptyStateWidget when notifications are empty',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationScreen(initialNotifications: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(emptyStateText), findsOneWidget);
    });

    testWidgets(
        'AcademicScheduleScreen renders EmptyStateWidget when schedules are cleared/empty',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Cleared schedule with empty entries
      final clearedSchedule = [
        DaySchedule(dayName: 'Monday', entries: []),
        DaySchedule(dayName: 'Tuesday', entries: []),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: AcademicScheduleScreen(initialSchedule: clearedSchedule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(emptyStateText), findsOneWidget);
    });

    testWidgets(
        'CardGroupsOverviewScreen switches to EmptyStateWidget after deleting all groups in selection mode',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final singleGroup = [
        const CardGroup(
          id: 'grp_single',
          title: 'Single Card Group',
          groupType: 'academic',
          backgroundColor: Color(0xFF1E1E1E),
          items: ['Item 1'],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: CardGroupsOverviewScreen(initialGroups: singleGroup),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Single Card Group'), findsOneWidget);
      expect(find.byType(EmptyStateWidget), findsNothing);

      // Enter selection mode
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      // Tap Delete in selection modal
      await tester.tap(find.text('Delete?'));
      await tester.pumpAndSettle();

      // UI should switch instantly to EmptyStateWidget
      expect(find.text('Single Card Group'), findsNothing);
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(emptyStateText), findsOneWidget);
    });

    testWidgets(
        'CardGroupDetailScreen switches to EmptyStateWidget after deleting all tasks in selection mode',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final List<CardTask> singleTask = [
        const CardTask(
          id: 'task-single',
          headerTitle: 'Academic Cards Group',
          subject: 'Desain Grafis',
          taskName: 'Unique Homework Task',
          priority: 'Urgent',
          status: 'On Progress',
          dueDate: '12 May 2024',
          backgroundColor: Color(0xFF1E1E1E),
        ),
      ];

      final group = CardGroup(
        id: 'academic',
        title: 'Academic Cards Group',
        groupType: 'academic',
        backgroundColor: const Color(0xFF1E1E1E),
        items: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CardGroupDetailScreen(
            group: group,
            initialTasks: singleTask,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unique Homework Task'), findsOneWidget);
      expect(find.byType(EmptyStateWidget), findsNothing);

      // Enter selection mode
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      // Tap Delete in selection modal
      await tester.tap(find.text('Delete?'));
      await tester.pumpAndSettle();

      // UI switches instantly to EmptyStateWidget
      expect(find.text('Unique Homework Task'), findsNothing);
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(emptyStateText), findsOneWidget);
    });

    testWidgets(
        'NotificationScreen switches to EmptyStateWidget after deleting all notifications in selection mode',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final List<NotificationItem> singleNotification = [
        const NotificationItem(
          id: 'notif-single',
          title: 'Single Task Notification',
          subtitle: 'Due tomorrow',
          cardTypeLabel: 'Academic Card',
          timeAgo: '1h ago',
          sectionGroup: 'Today',
          category: CardCategory.academic,
          indicatorColor: Color(0xFF1E1E1E),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: NotificationScreen(initialNotifications: singleNotification),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Single Task Notification'), findsOneWidget);
      expect(find.byType(EmptyStateWidget), findsNothing);

      // Enter selection mode
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      // Tap the item to select it
      await tester.tap(find.text('Single Task Notification'));
      await tester.pumpAndSettle();

      // Tap Delete Notification?
      await tester.tap(find.text('Delete Notification?'));
      await tester.pumpAndSettle();

      // UI switches instantly to EmptyStateWidget
      expect(find.text('Single Task Notification'), findsNothing);
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(emptyStateText), findsOneWidget);
    });
  });
}
