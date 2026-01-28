import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:aurora_assessment/core/generated/app_localizations.dart';
import 'package:aurora_assessment/features/random_image/presentation/widgets/pulling_color_button.dart';

Widget createTestWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('de')],
    home: Scaffold(body: child),
  );
}

void main() {
  group('PullingColorButton', () {
    testWidgets('renders correctly with gradient colors', (
      WidgetTester tester,
    ) async {
      const gradientColors = [Colors.blue, Colors.purple];

      await tester.pumpWidget(
        createTestWidget(
          const PullingColorButton(
            isLoading: false,
            gradientColors: gradientColors,
          ),
        ),
      );

      expect(find.byType(PullingColorButton), findsOneWidget);
    });

    testWidgets('shows text when not loading', (WidgetTester tester) async {
      const gradientColors = [Colors.blue, Colors.purple];

      await tester.pumpWidget(
        createTestWidget(
          const PullingColorButton(
            isLoading: false,
            gradientColors: gradientColors,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final textFinder = find.text('Another');
      expect(textFinder, findsOneWidget);
    });

    testWidgets('calls onPressed callback when tapped and not loading', (
      WidgetTester tester,
    ) async {
      const gradientColors = [Colors.blue, Colors.purple];
      bool callbackCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          PullingColorButton(
            isLoading: false,
            gradientColors: gradientColors,
            onPressed: () {
              callbackCalled = true;
            },
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byType(PullingColorButton));
      await tester.pump();

      expect(callbackCalled, isTrue);
    });

    testWidgets('does not call callback when onPressed is null', (
      WidgetTester tester,
    ) async {
      const gradientColors = [Colors.blue, Colors.purple];
      bool callbackCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          PullingColorButton(
            isLoading: true,
            gradientColors: gradientColors,
            onPressed: null,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byType(PullingColorButton));
      await tester.pump();

      expect(callbackCalled, isFalse);
    });

    testWidgets('updates when isLoading changes from false to true', (
      WidgetTester tester,
    ) async {
      const gradientColors = [Colors.blue, Colors.purple];

      await tester.pumpWidget(
        createTestWidget(
          const PullingColorButton(
            isLoading: false,
            gradientColors: gradientColors,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(
        createTestWidget(
          const PullingColorButton(
            isLoading: true,
            gradientColors: gradientColors,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PullingColorButton), findsOneWidget);
    });

    testWidgets('updates when isLoading changes from true to false', (
      WidgetTester tester,
    ) async {
      const gradientColors = [Colors.blue, Colors.purple];

      await tester.pumpWidget(
        createTestWidget(
          const PullingColorButton(
            isLoading: true,
            gradientColors: gradientColors,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(
        createTestWidget(
          const PullingColorButton(
            isLoading: false,
            gradientColors: gradientColors,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PullingColorButton), findsOneWidget);
    });

    testWidgets('handles null onPressed callback', (WidgetTester tester) async {
      const gradientColors = [Colors.blue, Colors.purple];

      await tester.pumpWidget(
        createTestWidget(
          const PullingColorButton(
            isLoading: false,
            gradientColors: gradientColors,
            onPressed: null,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byType(PullingColorButton));
      await tester.pump();

      expect(find.byType(PullingColorButton), findsOneWidget);
    });
  });
}
