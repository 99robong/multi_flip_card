import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_flip_card_example/main.dart';
import 'package:multi_flip_card/multi_flip_card.dart';

void main() {
  group('Multi Flip Card Example App Tests', () {
    testWidgets('should render app with correct title and initial UI', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Check app title and initial state
      expect(find.text('Multi Flip Card Demo'), findsOneWidget);
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsOneWidget);
      expect(find.text('세로 뒤집기\n앞면'), findsOneWidget);
      
      // Check all control buttons are present
      expect(find.text('토글'), findsOneWidget);
      expect(find.text('앞면으로'), findsOneWidget);
      expect(find.text('뒷면 1'), findsOneWidget);
      expect(find.text('뒷면 2'), findsOneWidget);
      expect(find.text('뒷면 3'), findsOneWidget);
    });

    testWidgets('should flip to back when front FlipTrigger is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Verify initial state
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsOneWidget);
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsNothing);

      // Tap the front card to flip
      await tester.tap(find.text('앞면\n(탭해서 뒤집기)'));
      await tester.pumpAndSettle();

      // Should now show first back card
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsNothing);
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsOneWidget);
    });

    testWidgets('should flip back to front when back card FlipTrigger is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // First flip to back
      await tester.tap(find.text('앞면\n(탭해서 뒤집기)'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsOneWidget);

      // Tap back card to flip to front
      await tester.tap(find.text('뒷면 1\n(탭해서 앞면으로)'));
      await tester.pumpAndSettle();

      // Should be back to front
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsOneWidget);
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsNothing);
    });

    testWidgets('should control card with toggle button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Initially showing front
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsOneWidget);

      // Tap toggle button
      await tester.tap(find.text('토글'));
      await tester.pumpAndSettle();

      // Should show first back
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsOneWidget);

      // Tap toggle again
      await tester.tap(find.text('토글'));
      await tester.pumpAndSettle();

      // Should be back to front
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsOneWidget);
    });

    testWidgets('should navigate to specific back cards using buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Test flip to back 1
      await tester.tap(find.text('뒷면 1'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsOneWidget);

      // Test flip to back 2
      await tester.tap(find.text('뒷면 2'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 2'), findsOneWidget);
      expect(find.text('앞면으로'), findsOneWidget);
      expect(find.text('뒷면 1로'), findsOneWidget);

      // Test flip to back 3
      await tester.tap(find.text('뒷면 3'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 3\n(토글)'), findsOneWidget);

      // Test flip back to front
      await tester.tap(find.text('앞면으로'));
      await tester.pumpAndSettle();
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsOneWidget);
    });

    testWidgets('should handle FlipTrigger actions in back card 2', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to back card 2
      await tester.tap(find.text('뒷면 2'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 2'), findsOneWidget);

      // Test "앞면으로" button in back card 2
      await tester.tap(find.text('앞면으로'));
      await tester.pumpAndSettle();
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsOneWidget);

      // Go back to back card 2
      await tester.tap(find.text('뒷면 2'));
      await tester.pumpAndSettle();

      // Test "뒷면 1로" button in back card 2
      await tester.tap(find.text('뒷면 1로'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsOneWidget);
    });

    testWidgets('should handle back card 3 toggle functionality', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to back card 3
      await tester.tap(find.text('뒷면 3'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 3\n(토글)'), findsOneWidget);

      // Tap the toggle trigger in back card 3
      await tester.tap(find.text('뒷면 3\n(토글)'));
      await tester.pumpAndSettle();

      // Should flip back to front (toggle behavior)
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsOneWidget);
    });

    testWidgets('should handle vertical flip card correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Check initial state of vertical card
      expect(find.text('세로 뒤집기\n앞면'), findsOneWidget);
      expect(find.text('세로 뒤집기\n뒷면'), findsNothing);

      // Tap vertical card front
      await tester.tap(find.text('세로 뒤집기\n앞면'));
      await tester.pumpAndSettle();

      // Should show vertical card back
      expect(find.text('세로 뒤집기\n앞면'), findsNothing);
      expect(find.text('세로 뒤집기\n뒷면'), findsOneWidget);

      // Tap vertical card back to return to front
      await tester.tap(find.text('세로 뒤집기\n뒷면'));
      await tester.pumpAndSettle();

      // Should be back to front
      expect(find.text('세로 뒤집기\n앞면'), findsOneWidget);
      expect(find.text('세로 뒤집기\n뒷면'), findsNothing);
    });

    testWidgets('should maintain independent states for different cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Flip main card to back
      await tester.tap(find.text('토글'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsOneWidget);

      // Vertical card should still show front
      expect(find.text('세로 뒤집기\n앞면'), findsOneWidget);

      // Flip vertical card
      await tester.tap(find.text('세로 뒤집기\n앞면'));
      await tester.pumpAndSettle();

      // Main card should still show back 1, vertical card should show back
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsOneWidget);
      expect(find.text('세로 뒤집기\n뒷면'), findsOneWidget);
    });

    testWidgets('should handle rapid button presses correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Rapidly press different back buttons
      await tester.tap(find.text('뒷면 1'));
      await tester.pump(const Duration(milliseconds: 100));
      
      await tester.tap(find.text('뒷면 2'));
      await tester.pump(const Duration(milliseconds: 100));
      
      await tester.tap(find.text('뒷면 3'));
      await tester.pumpAndSettle();

      // Should end up on back 3
      expect(find.text('뒷면 3\n(토글)'), findsOneWidget);
    });

    testWidgets('should have correct widget hierarchy and structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Check for main structural widgets
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(MultiFlipCard), findsNWidgets(2)); // Main card + vertical card
      expect(find.byType(FlipTrigger), findsAtLeastNWidgets(1));
      expect(find.byType(ElevatedButton), findsNWidgets(5)); // 5 control buttons
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('should handle card dimensions correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Find the main card container and verify its appearance
      final mainCardContainer = find.byType(Container).first;
      expect(mainCardContainer, findsOneWidget);

      // The cards should be visible and properly sized
      final cardWidgets = find.byType(MultiFlipCard);
      expect(cardWidgets, findsNWidgets(2));
    });

    testWidgets('should display all text content correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Check Korean text is displayed properly
      expect(find.text('앞면\n(탭해서 뒤집기)'), findsOneWidget);
      expect(find.text('세로 뒤집기\n앞면'), findsOneWidget);

      // Navigate through all backs to check text
      await tester.tap(find.text('뒷면 1'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsOneWidget);

      await tester.tap(find.text('뒷면 2'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 2'), findsOneWidget);

      await tester.tap(find.text('뒷면 3'));
      await tester.pumpAndSettle();
      expect(find.text('뒷면 3\n(토글)'), findsOneWidget);
    });

    group('Edge Cases', () {
      testWidgets('should handle multiple rapid taps on same trigger', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(const MyApp());

        // Rapidly tap the same button multiple times
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.text('토글'));
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();

        // Should end up in a consistent state (back, since odd number of taps)
        expect(find.text('뒷면 1\n(탭해서 앞면으로)'), findsOneWidget);
      });

      testWidgets('should maintain state when scrolling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(const MyApp());

        // Flip to a back card
        await tester.tap(find.text('뒷면 2'));
        await tester.pumpAndSettle();
        expect(find.text('뒷면 2'), findsOneWidget);

        // Simulate scroll (drag gesture)
        await tester.drag(find.byType(Column), const Offset(0, -100));
        await tester.pumpAndSettle();

        // State should be maintained
        expect(find.text('뒷면 2'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantics for screen readers', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(const MyApp());

        // Check that text widgets are semantically accessible
        expect(
          tester.getSemantics(find.text('앞면\n(탭해서 뒤집기)')),
          matchesSemantics(
            label: '앞면\n(탭해서 뒤집기)',
          ),
        );

        expect(
          tester.getSemantics(find.text('토글')),
          matchesSemantics(
            label: '토글',
            isButton: true,
          ),
        );
      });
    });
  });
}