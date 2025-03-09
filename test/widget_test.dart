import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adoption_travel_list/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the main screen loads
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Adoption & Travel Plans'), findsOneWidget);
  });
}
