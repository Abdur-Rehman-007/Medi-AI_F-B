// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:medi_ai/main.dart';

void main() {
  testWidgets('Medi-AI app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MediAIApp());

    // Verify that the splash screen or login screen loads
    // Note: This is a basic test. Add more specific tests as needed.
    expect(find.byType(MediAIApp), findsOneWidget);
  });
}
