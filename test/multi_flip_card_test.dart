import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_flip_card/multi_flip_card.dart';

void main() {
  group('MultiFlipCard', () {
    testWidgets('should render front widget initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFlipCard(
              front: const Text('Front'),
              backs: const [Text('Back')],
            ),
          ),
        ),
      );

      expect(find.text('Front'), findsOneWidget);
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('should flip when FlipTrigger is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFlipCard(
              front: const FlipTrigger(child: Text('Front')),
              backs: const [Text('Back')],
            ),
          ),
        ),
      );

      // Initially showing front
      expect(find.text('Front'), findsOneWidget);
      expect(find.text('Back'), findsNothing);

      // Tap to flip
      await tester.tap(find.text('Front'));
      await tester.pumpAndSettle();

      // Should now show back
      expect(find.text('Front'), findsNothing);
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('should work with controller', (WidgetTester tester) async {
      final controller = MultiFlipCardController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFlipCard(
              controller: controller,
              front: const Text('Front'),
              backs: const [Text('Back1'), Text('Back2')],
            ),
          ),
        ),
      );

      // Initially showing front
      expect(find.text('Front'), findsOneWidget);
      expect(controller.isFlipped, false);

      // Flip using controller
      controller.flip();
      await tester.pumpAndSettle();

      expect(find.text('Back1'), findsOneWidget);
      expect(controller.isFlipped, true);
      expect(controller.currentBackIndex, 0);

      // Flip to specific back
      controller.flipToBack(1);
      await tester.pumpAndSettle();

      expect(find.text('Back2'), findsOneWidget);
      expect(controller.currentBackIndex, 1);

      // Flip to front
      controller.flipToFront();
      await tester.pumpAndSettle();

      expect(find.text('Front'), findsOneWidget);
      expect(controller.isFlipped, false);
    });

    testWidgets('should start flipped if isFlipped is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFlipCard(
              isFlipped: true,
              front: const Text('Front'),
              backs: const [Text('Back')],
            ),
          ),
        ),
      );

      expect(find.text('Front'), findsNothing);
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('should handle multiple backs correctly', (
      WidgetTester tester,
    ) async {
      final controller = MultiFlipCardController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFlipCard(
              controller: controller,
              front: const Text('Front'),
              backs: const [Text('Back1'), Text('Back2'), Text('Back3')],
            ),
          ),
        ),
      );

      // Test flipping to each back
      for (int i = 0; i < 3; i++) {
        controller.flipToBack(i);
        await tester.pumpAndSettle();

        expect(find.text('Back${i + 1}'), findsOneWidget);
        expect(controller.currentBackIndex, i);
      }
    });
  });

  group('FlipTrigger', () {
    testWidgets('should perform correct actions', (WidgetTester tester) async {
      final controller = MultiFlipCardController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFlipCard(
              controller: controller,
              front: Column(
                children: [
                  FlipTrigger(
                    action: FlipAction.toggle,
                    child: const Text('Toggle'),
                  ),
                  FlipTrigger(
                    action: FlipAction.flipToBack,
                    backIndex: 1,
                    child: const Text('To Back 2'),
                  ),
                ],
              ),
              backs: [
                const Text('Back1'),
                FlipTrigger(
                  action: FlipAction.flipToFront,
                  child: const Text('Back2 - To Front'),
                ),
              ],
            ),
          ),
        ),
      );

      // Test toggle
      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();
      expect(controller.isFlipped, true);
      expect(controller.currentBackIndex, 0);

      // Test flip to specific back
      await tester.tap(find.text('To Back 2'));
      await tester.pumpAndSettle();
      expect(controller.currentBackIndex, 1);

      // Test flip to front
      await tester.tap(find.text('Back2 - To Front'));
      await tester.pumpAndSettle();
      expect(controller.isFlipped, false);
    });
  });
}
