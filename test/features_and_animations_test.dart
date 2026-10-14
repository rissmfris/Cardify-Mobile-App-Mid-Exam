import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cardify_mobile/core/constants/app_routes.dart';
import 'package:cardify_mobile/core/widgets/smooth_switch_toggle.dart';
import 'package:cardify_mobile/core/widgets/task_priority_badge.dart';
import 'package:cardify_mobile/features/card_management/models/card_group.dart';
import 'package:cardify_mobile/features/card_management/presentation/screens/card_groups_overview_screen.dart';
import 'package:cardify_mobile/features/card_management/presentation/screens/card_group_detail_screen.dart';
import 'package:cardify_mobile/features/card_management/presentation/screens/add_card_form_screen.dart';
import 'package:cardify_mobile/features/dashboard/presentation/widgets/add_cards_popover.dart';
import 'package:cardify_mobile/features/dashboard/presentation/widgets/bottom_dock_nav_bar.dart';
import 'package:cardify_mobile/main.dart';

void main() {
  group('1. "Your Card Groups" Screen - Pencil Icon Refactor & Selection Mode', () {
    testWidgets('Tapping top-right pencil icon toggles delete/selection mode',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: CardGroupsOverviewScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state: edit/pencil icon is displayed
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);

      // Tap pencil icon to enter selection mode
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      // Pencil icon changes to check_circle_rounded
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsNothing);

      // Delete modal appears with selected items
      expect(find.text('Delete?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Tap Cancel to exit selection mode
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Returns to edit_outlined icon
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.text('Delete?'), findsNothing);
    });

    testWidgets('Delete selected card group in Selection Mode',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: CardGroupsOverviewScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Initial count of card groups: Academic, Organization, Community
      expect(find.text('Academic Card Group'), findsOneWidget);
      expect(find.text('Organization Card Group'), findsOneWidget);

      // Enter selection mode via pencil icon
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      // Tap Delete?
      await tester.tap(find.text('Delete?'));
      await tester.pumpAndSettle();

      // The pre-selected Academic Card Group should now be removed
      expect(find.text('Academic Card Group'), findsNothing);
      expect(find.text('Organization Card Group'), findsOneWidget);
      expect(find.text('1 Card Group(s) deleted'), findsOneWidget);
    });
  });

  group('2. Automated Priority Badges (Static Display) & SnackBar Positioning', () {
    testWidgets('TaskPriorityBadge renders static color-coded badge without interactive menu',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TaskPriorityBadge(priority: 'Low'),
                TaskPriorityBadge(priority: 'Medium'),
                TaskPriorityBadge(priority: 'Urgent'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // All 3 badges render
      expect(find.text('Low'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Urgent'), findsOneWidget);

      // Verify no dropdown chevron exists
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsNothing);

      // Tapping badge does not open any popup menu
      await tester.tap(find.text('Urgent'));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuButton), findsNothing);
      expect(find.byType(PopupMenuItem), findsNothing);
    });

    testWidgets('AddCardFormScreen auto-assigns priority from deadline & positions SnackBar above navigation dock',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      CardTask? addedTask;

      await tester.pumpWidget(
        MaterialApp(
          home: AddCardFormScreen(
            onCardAdded: (task) {
              addedTask = task;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify automated Priority Level section is displayed
      expect(find.text('Priority Level'), findsOneWidget);
      expect(find.text('Automated based on deadline'), findsOneWidget);
      expect(find.text('Urgent'), findsOneWidget);

      // Enter assignment name
      await tester.enterText(
          find.widgetWithText(TextField, 'Insert assignment'), 'Design Architecture');
      await tester.pumpAndSettle();

      // Scroll to and tap 'Add Cards'
      await tester.ensureVisible(find.text('Add Cards'));
      await tester.tap(find.text('Add Cards'));
      await tester.pump(); // Start SnackBar animation

      // Verify SnackBar appears with safe bottom margin >= 90 clearing the bottom navigation bar
      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);

      final SnackBar snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.behavior, SnackBarBehavior.floating);
      expect(snackBar.margin, isNotNull);
      final margin = snackBar.margin as EdgeInsets;
      expect(margin.bottom, greaterThanOrEqualTo(90.0));

      await tester.pumpAndSettle();

      expect(addedTask, isNotNull);
      expect(addedTask!.priority, 'Urgent');
      expect(addedTask!.taskName, 'Design Architecture');
    });
  });

  group('3. Bottom Navigation Bar Expanded Touch Targets', () {
    testWidgets('All 5 items in BottomDockNavBar have expanded hit targets',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      int selectedNav = 0;
      bool addPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomDockNavBar(
              selectedIndex: selectedNav,
              onItemSelected: (index) {
                selectedNav = index;
              },
              onAddPressed: () {
                addPressed = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify all 5 Expanded widgets exist in the Row
      final expandedWidgets = find.descendant(
        of: find.byType(Row),
        matching: find.byType(Expanded),
      );
      expect(expandedWidgets, findsNWidgets(5));

      // Test tapping tab 1 (Card Groups)
      await tester.tap(find.byTooltip('Card Groups'));
      await tester.pumpAndSettle();
      expect(selectedNav, 1);

      // Test tapping center '+' button
      await tester.tap(find.byTooltip('Add Cards'));
      await tester.pumpAndSettle();
      expect(addPressed, isTrue);

      // Test tapping tab 3 (Profile)
      await tester.tap(find.byTooltip('Profile'));
      await tester.pumpAndSettle();
      expect(selectedNav, 3);
    });
  });

  group('4. Smooth UI Animations', () {
    testWidgets('SmoothSwitchToggle animates thumb sliding smoothly',
        (WidgetTester tester) async {
      bool toggleVal = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SmoothSwitchToggle(
                  value: toggleVal,
                  onChanged: (val) {
                    setState(() {
                      toggleVal = val;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(toggleVal, isFalse);

      // Tap switch
      await tester.tap(find.byType(SmoothSwitchToggle));
      // Pump halfway through animation (130ms)
      await tester.pump(const Duration(milliseconds: 130));
      expect(toggleVal, isTrue);

      // Settle animation
      await tester.pumpAndSettle();
      expect(toggleVal, isTrue);
    });

    testWidgets('Center "+" Popover opens with smooth scale and fade transition',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const CardifyApp(initialRoute: AppRoutes.dashboard));
      await tester.pumpAndSettle();

      // Tap '+' button
      await tester.tap(find.byTooltip('Add Cards'));
      await tester.pump(const Duration(milliseconds: 100)); // partial animation

      // Settle popup
      await tester.pumpAndSettle();

      expect(find.byType(AddCardsPopover), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AddCardsPopover),
          matching: find.text('Academic Card'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AddCardsPopover),
          matching: find.text('Organization Card'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AddCardsPopover),
          matching: find.text('Community Card'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AddCardsPopover),
          matching: find.text('Add Other Card Group'),
        ),
        findsOneWidget,
      );
    });
  });

  group('5. Card Interaction - Long Press / Hold to Delete', () {
    testWidgets('Long pressing card on Dashboard opens delete confirmation dialog',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const CardifyApp(initialRoute: AppRoutes.dashboard));
      await tester.pumpAndSettle();

      expect(find.text('Membuat Nirmana 3D'), findsOneWidget);

      // Long press (hold) on task card
      await tester.longPress(find.text('Membuat Nirmana 3D'));
      await tester.pumpAndSettle();

      // Dialog confirmation appears
      expect(find.text('Delete Card?'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "Membuat Nirmana 3D"?'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Card is removed from Dashboard immediately
      expect(find.text('Membuat Nirmana 3D'), findsNothing);
      expect(find.text('Card "Membuat Nirmana 3D" deleted'), findsOneWidget);
    });

    testWidgets('Long pressing card in CardGroupDetailScreen opens delete confirmation dialog',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: CardGroupDetailScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Membuat Nirmana 3D'), findsWidgets);

      // Long press first task card
      await tester.longPress(find.text('Membuat Nirmana 3D').first);
      await tester.pumpAndSettle();

      // Confirmation dialog appears
      expect(find.text('Delete Card?'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "Membuat Nirmana 3D"?'),
          findsOneWidget);

      // Cancel deletion in dialog
      await tester.tap(find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Cancel'),
      ));
      await tester.pumpAndSettle();

      // Card remains intact
      expect(find.text('Membuat Nirmana 3D'), findsWidgets);
    });
  });
}
