// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:p018/main.dart';

void main() {
  testWidgets('App shows crossword clues and controls', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CrosswordApp());

    // Verify that the crossword UI appears and the Check Answers button exists.
    expect(find.text('Across'), findsOneWidget);
    expect(find.text('Down'), findsOneWidget);
    expect(find.text('Check Answers'), findsOneWidget);
  });
}
