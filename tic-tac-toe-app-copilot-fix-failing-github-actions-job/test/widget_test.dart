import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neon_tic_tac_toe/main.dart';

void main() {
  testWidgets('Game screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the game title is displayed.
    expect(find.text('NEON TIC TAC TOE'), findsOneWidget);

    // Verify that the board is displayed.
    expect(find.byType(GestureDetector), findsNWidgets(9));

    // Verify that player indicators are displayed.
    expect(find.text('X'), findsWidgets);
    expect(find.text('O'), findsWidgets);
  });

  testWidgets('Make a move', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap on the first cell.
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // Verify that the X is displayed.
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('Reset game', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Make a move.
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // Tap the reset button.
    await tester.tap(find.text('New Game'));
    await tester.pump();

    // Verify that the board is reset.
    expect(find.byType(CustomPaint), findsNothing);
  });
}