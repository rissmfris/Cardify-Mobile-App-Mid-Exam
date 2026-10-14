import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cardify_mobile/core/constants/app_routes.dart';
import 'package:cardify_mobile/core/constants/app_typography.dart';
import 'package:cardify_mobile/core/theme/app_theme.dart';
import 'package:cardify_mobile/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Inter Font Theme & Weight Verification', () {
    testWidgets('Verify Inter font family and weight inheritance across all weights', (tester) async {
      final theme = AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Column(
                  children: [
                    // Default theme text
                    Text('Regular Body', style: Theme.of(context).textTheme.bodyMedium),
                    // AppTypography
                    const Text('Brand Header', style: AppTypography.brandHeader),
                    const Text('Input Text', style: AppTypography.inputText),
                    const Text('Button Text', style: AppTypography.buttonText),
                    const Text('Hero Title', style: AppTypography.heroTitle),
                    // Direct TextStyle without fontFamily
                    const Text(
                      'Regular Direct',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    const Text(
                      'Medium Direct',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      'SemiBold Direct',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      'Bold Direct',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    // Text with no style at all
                    const Text('No Style Text'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Verify DefaultTextStyle
      final defaultTextStyle = DefaultTextStyle.of(tester.element(find.text('No Style Text')));
      expect(defaultTextStyle.style.fontFamily, contains('Inter'));

      // Verify effective text styles
      final texts = [
        'Regular Body',
        'Brand Header',
        'Input Text',
        'Button Text',
        'Hero Title',
        'Regular Direct',
        'Medium Direct',
        'SemiBold Direct',
        'Bold Direct',
        'No Style Text',
      ];

      for (final text in texts) {
        final textWidget = tester.widget<Text>(find.text(text));
        final element = tester.element(find.text(text));
        final ambient = DefaultTextStyle.of(element).style;
        final effective = ambient.merge(textWidget.style);
        
        expect(effective.fontFamily, contains('Inter'), reason: '$text must inherit Inter font family');
      }
    });

    testWidgets('Verify UI components inherit Inter font (Buttons, Inputs, Badges, AppBar)', (tester) async {
      await tester.pumpWidget(
        const CardifyApp(initialRoute: AppRoutes.onboarding),
      );
      await tester.pumpAndSettle();

      // Find all Text widgets rendered on Onboarding screen
      final textFinder = find.byType(Text);
      expect(textFinder, findsWidgets);

      for (final element in textFinder.evaluate()) {
        final textWidget = element.widget as Text;
        final ambient = DefaultTextStyle.of(element).style;
        final effective = ambient.merge(textWidget.style);
        expect(
          effective.fontFamily,
          contains('Inter'),
          reason: 'Text "${textWidget.data}" should inherit Inter font family',
        );
      }
    });

    testWidgets('Verify Dashboard Screen text inherits Inter font family', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const CardifyApp(initialRoute: AppRoutes.dashboard),
      );
      await tester.pumpAndSettle();

      final welcomeFinder = find.text('Welcome, Eky');
      expect(welcomeFinder, findsOneWidget);

      final element = tester.element(welcomeFinder);
      final textWidget = tester.widget<Text>(welcomeFinder);
      final ambient = DefaultTextStyle.of(element).style;
      final effective = ambient.merge(textWidget.style);

      expect(effective.fontFamily, contains('Inter'));
      expect(effective.fontWeight, FontWeight.w800);

      // Verify card label
      final academicFinder = find.text('Academic Card');
      expect(academicFinder, findsOneWidget);
      final academicEl = tester.element(academicFinder);
      final academicWidget = tester.widget<Text>(academicFinder);
      final academicEffective = DefaultTextStyle.of(academicEl).style.merge(academicWidget.style);
      expect(academicEffective.fontFamily, contains('Inter'));
    });

    testWidgets('Verify My Cards (Card Groups) Screen text inherits Inter font family', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const CardifyApp(initialRoute: AppRoutes.cardGroups),
      );
      await tester.pumpAndSettle();

      final textFinder = find.byType(Text);
      expect(textFinder, findsWidgets);

      for (final element in textFinder.evaluate()) {
        final textWidget = element.widget as Text;
        final ambient = DefaultTextStyle.of(element).style;
        final effective = ambient.merge(textWidget.style);
        expect(
          effective.fontFamily,
          contains('Inter'),
          reason: 'Text "${textWidget.data}" on Card Groups screen should inherit Inter',
        );
      }
    });

    testWidgets('Verify Academic Schedule Screen text inherits Inter font family', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const CardifyApp(initialRoute: AppRoutes.academicSchedule),
      );
      await tester.pumpAndSettle();

      final textFinder = find.byType(Text);
      expect(textFinder, findsWidgets);

      for (final element in textFinder.evaluate()) {
        final textWidget = element.widget as Text;
        final ambient = DefaultTextStyle.of(element).style;
        final effective = ambient.merge(textWidget.style);
        expect(
          effective.fontFamily,
          contains('Inter'),
          reason: 'Text "${textWidget.data}" on Academic Schedule screen should inherit Inter',
        );
      }
    });

    testWidgets('Verify Profile Screen text inherits Inter font family', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const CardifyApp(initialRoute: AppRoutes.profile),
      );
      await tester.pumpAndSettle();

      final textFinder = find.byType(Text);
      expect(textFinder, findsWidgets);

      for (final element in textFinder.evaluate()) {
        final textWidget = element.widget as Text;
        final ambient = DefaultTextStyle.of(element).style;
        final effective = ambient.merge(textWidget.style);
        expect(
          effective.fontFamily,
          contains('Inter'),
          reason: 'Text "${textWidget.data}" on Profile screen should inherit Inter',
        );
      }
    });

    testWidgets('Verify Add Card Form Screen text and form inputs inherit Inter font family', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const CardifyApp(initialRoute: AppRoutes.addCard),
      );
      await tester.pumpAndSettle();

      final textFinder = find.byType(Text);
      expect(textFinder, findsWidgets);

      for (final element in textFinder.evaluate()) {
        final textWidget = element.widget as Text;
        final ambient = DefaultTextStyle.of(element).style;
        final effective = ambient.merge(textWidget.style);
        expect(
          effective.fontFamily,
          contains('Inter'),
          reason: 'Text "${textWidget.data}" on Add Card screen should inherit Inter',
        );
      }
    });
  });
}
