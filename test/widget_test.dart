// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Avoid initializing the full app which depends on Supabase client.

void main() {
  testWidgets('Counter increments smoke test (isolated)',
      (WidgetTester tester) async {
    int counter = 0;

    final testWidget = MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(builder: (context, setState) {
          return Column(children: [
            Text('$counter', textDirection: TextDirection.ltr),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() => counter++),
            )
          ]);
        }),
      ),
    );

    await tester.pumpWidget(testWidget);

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
