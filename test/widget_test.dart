import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sih_flutter_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('App displays welcome message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the welcome message is displayed.
    expect(find.text('Welcome to Smart India Hackathon!'), findsOneWidget);
    expect(find.text('This is your Flutter starter code.'), findsOneWidget);
  });

  testWidgets('Features button navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find and tap the explore features button.
    await tester.tap(find.text('Explore Features'));
    await tester.pumpAndSettle();

    // Verify that we navigated to the features screen.
    expect(find.text('SIH Features'), findsOneWidget);
    expect(find.text('Available Features'), findsOneWidget);
  });
}