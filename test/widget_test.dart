import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cardify_mobile/core/constants/app_routes.dart';
import 'package:cardify_mobile/main.dart';

void main() {
  testWidgets('Dashboard and Notification flow smoke test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // 1. Launch with Dashboard as initial route
    await tester.pumpWidget(const CardifyApp(initialRoute: AppRoutes.dashboard));
    await tester.pumpAndSettle();

    // Verify Dashboard Screen 1 elements
    expect(find.text('Welcome, Eky'), findsOneWidget);
    expect(find.text('Academic Card'), findsOneWidget);
    expect(find.text('Organization Card'), findsOneWidget);
    expect(find.text('Community Card'), findsOneWidget);
    expect(find.text('Feeds Content'), findsOneWidget);

    // 2. Test '+' Add Button triggering Screen 3 (Add Cards Popover)
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add Cards'), findsOneWidget);
    expect(find.text('Add Other Card Group'), findsOneWidget);

    // Tap outside to dismiss popover
    await tester.tapAt(const Offset(20, 50));
    await tester.pumpAndSettle();
    expect(find.text('Add Other Card Group'), findsNothing);

    // 3. Navigate to Screen 2 (Notification Screen) via Bell Icon
    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Notification'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);

    // Verify Notification items from PDF
    expect(find.text('Desain dan Pemrograman Website'), findsOneWidget);
    expect(find.text('Rapat Bidang'), findsOneWidget);
    expect(find.text('Asset Sosmed'), findsOneWidget);

    // 4. Test Selection Mode via edit icon
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.textContaining('Items Selected'), findsOneWidget);
    expect(find.text('Delete Notification?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Cancel selection mode
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // 5. Back navigation to Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Eky'), findsOneWidget);
  });

  testWidgets(
      'Authentication to Dashboard navigation test via pushReplacement',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Launch with Onboarding as initial route
    await tester.pumpWidget(const CardifyApp(initialRoute: AppRoutes.onboarding));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Cardify'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Skip to Auth Gateway (Screen 6)
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome,'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    // Navigate to Sign In (Screen 7)
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Insert Username/email'), findsOneWidget);

    // Enter username & password
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Insert Username/email'), 'eky');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Insert Password'), 'password123');
    await tester.pumpAndSettle();

    // Tap primary "Sign In" button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    // Verify seamless replacement to Dashboard screen
    expect(find.text('Welcome, Eky'), findsOneWidget);
    expect(find.text('Academic Card'), findsOneWidget);
  });

  testWidgets('My Cards management flow test across screens',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // 1. Launch with CardGroups as initial route
    await tester.pumpWidget(const CardifyApp(initialRoute: AppRoutes.cardGroups));
    await tester.pumpAndSettle();

    // Verify Screen 1: Your Card Groups
    expect(find.text('Your Card Groups'), findsOneWidget);
    expect(find.text('Add Card Group'), findsOneWidget);
    expect(find.text('Academic Card Group'), findsOneWidget);
    expect(find.text('Organization Card Group'), findsOneWidget);
    expect(find.text('Community Card Group'), findsOneWidget);

    // 2. Navigate to Screen 2: Add Card Group
    await tester.tap(find.text('Add Card Group'));
    await tester.pumpAndSettle();

    expect(find.text('Add Card Group'), findsOneWidget);
    expect(find.text('Group Card Name'), findsOneWidget);
    expect(find.text('Himapedia'), findsOneWidget);
    expect(find.text('+ Add Category'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);

    // Cancel back to Screen 1
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Your Card Groups'), findsOneWidget);

    // 3. Navigate to Screen 4: Academic Cards Group
    await tester.tap(find.text('Academic Card Group'));
    await tester.pumpAndSettle();

    expect(find.text('Academic Cards Group'), findsOneWidget);
    expect(find.text('Add Academic Card'), findsOneWidget);

    // 4. Navigate to Screen 5: Add Academic Card
    await tester.tap(find.text('Add Academic Card'));
    await tester.pumpAndSettle();

    expect(find.text('Add Academic Card'), findsOneWidget);
    expect(find.text('Assignment Name'), findsOneWidget);
    expect(find.text('Add Cards'), findsOneWidget);

    // Go back
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Academic Cards Group'), findsOneWidget);

    // Go back to Screen 1
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Your Card Groups'), findsOneWidget);
  });

  testWidgets('Academic Schedule overview and edit flow test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // 1. Launch with Dashboard as initial route
    await tester.pumpWidget(const CardifyApp(initialRoute: AppRoutes.dashboard));
    await tester.pumpAndSettle();

    // 2. Navigate to Academic Schedule via Calendar Icon in header
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();

    // Verify Screen 1: Academic Schedule Overview (Root Tab)
    expect(find.text('Academic Schedule'), findsOneWidget);
    expect(find.text('Activate Schedule Reminder'), findsOneWidget);
    expect(find.text('Day'), findsOneWidget);
    expect(find.text('Subject'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);

    // Verify NO back button and NO floating action button on main schedule root view
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);

    // Verify schedule items from PDF
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('Psikologi Persepsi'), findsOneWidget);
    expect(find.text('09.20 - 12.00'), findsOneWidget);
    expect(find.text('Tuesday'), findsOneWidget);
    expect(find.text('Landasan Pendidikan'), findsOneWidget);
    expect(find.text('Wednesday'), findsOneWidget);
    expect(find.text('Design Thinking'), findsOneWidget);
    expect(find.text('Thursday'), findsOneWidget);
    expect(find.text('Pengelolaan Kelas'), findsOneWidget);

    // Test reminder toggle
    await tester.tap(find.text('Activate Schedule Reminder'));
    await tester.pumpAndSettle();

    // 3. Navigate to Screen 2: Edit Academic Schedule via top-right pencil icon
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    // Verify Screen 2: Edit Form (Sub-view has back button)
    expect(find.text('Academic Schedule'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    expect(find.text('+ Add Subject'), findsWidgets);
    expect(find.text('Save Schedule'), findsOneWidget);

    // Test dynamic "+ Add Subject"
    await tester.tap(find.text('+ Add Subject').first);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsWidgets);
    expect(find.byIcon(Icons.access_time_rounded), findsWidgets);

    // Enter a new subject into an input field
    await tester.enterText(find.byType(TextField).first, 'Kecerdasan Buatan');
    await tester.pumpAndSettle();
    expect(find.text('Kecerdasan Buatan'), findsOneWidget);

    // Test removing a subject slot with the red minus button
    await tester.tap(find.byIcon(Icons.remove_rounded).first);
    await tester.pumpAndSettle();

    // Save schedule and return to Overview
    await tester.tap(find.text('Save Schedule'));
    await tester.pumpAndSettle();

    // Pump past SnackBar duration so bottom dock is fully clear
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('Academic Schedule'), findsOneWidget);
    expect(find.text('Activate Schedule Reminder'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

    // 4. Test bottom dock home tab returning to Dashboard
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Eky'), findsOneWidget);
  });

  testWidgets('Profile screen, sections, and dialogs flow test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // 1. Launch with Profile as initial route
    await tester.pumpWidget(const CardifyApp(initialRoute: AppRoutes.profile));
    await tester.pumpAndSettle();

    // Verify Screen 1: Profile Root Elements
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

    // Verify Account Section
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('rezky4478@gmail.com'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
    expect(find.text('Log Out from this account'), findsOneWidget);

    // Verify Help Section is removed
    expect(find.text('Help'), findsNothing);
    expect(find.text('How To'), findsNothing);
    expect(find.text('Report Bug'), findsNothing);
    expect(find.text('FAQ'), findsNothing);

    // Verify Preference Section
    expect(find.text('Preference'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Themes'), findsOneWidget);

    // Scroll down to reveal Settings Section
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Verify Settings Section (About Us and Privacy Policy removed)
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Notification'), findsOneWidget);
    expect(find.text('About Us'), findsNothing);
    expect(find.text('Privacy Policy'), findsNothing);

    // Scroll back up to test top sections
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pumpAndSettle();

    // 2. Test Edit Profile Picture Modal
    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('Changes your Profile Picture'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);

    // Select Gallery
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    expect(find.text('Changes your Profile Picture'), findsNothing);

    // 3. Test Choose Language Modal
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.text('Choose Language'), findsOneWidget);
    expect(find.text('Bahasa Indonesia'), findsOneWidget);
    expect(find.text('English (UK)'), findsOneWidget);

    // Select Bahasa Indonesia
    await tester.tap(find.text('Bahasa Indonesia'));
    await tester.pumpAndSettle();
    expect(find.text('Choose Language'), findsNothing);

    // 4. Test Log Out Confirmation Dialog
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure want to Log Out?'), findsOneWidget);
    expect(find.text('Yes, Log Out'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Test Cancel button dismisses
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Are you sure want to Log Out?'), findsNothing);
    expect(find.text('Profile'), findsOneWidget);

    // Tap Log Out again and confirm
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes, Log Out'));
    await tester.pumpAndSettle();

    // Verify navigated back to Onboarding flow
    expect(find.text('Welcome to Cardify'), findsOneWidget);
  });

  testWidgets(
      'Interactive task card status badge dropdown updates status dynamically',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // 1. Launch with Dashboard where Academic Card is rendered
    await tester.pumpWidget(const CardifyApp(initialRoute: AppRoutes.dashboard));
    await tester.pumpAndSettle();

    // Verify initial "On Progress" status badges exist on dashboard cards
    expect(find.text('On Progress'), findsWidgets);

    // 2. Tap the first "On Progress" status badge
    await tester.tap(find.text('On Progress').first);
    await tester.pumpAndSettle();

    // Verify the dropdown popup menu displays exactly the 3 status options
    expect(find.text('Not Started'), findsOneWidget);
    expect(find.text('On Progress'), findsWidgets);
    expect(find.text('Done'), findsOneWidget);

    // 3. Select 'Done' from popup menu
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Verify that the card's status text has dynamically updated to 'Done'
    expect(find.text('Done'), findsOneWidget);

    // 4. Tap the 'Done' badge to open the menu again
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('Not Started'), findsOneWidget);

    // 5. Select 'Not Started'
    await tester.tap(find.text('Not Started'));
    await tester.pumpAndSettle();

    // Verify that the card's status text has dynamically updated to 'Not Started'
    expect(find.text('Not Started'), findsOneWidget);
  });
}
