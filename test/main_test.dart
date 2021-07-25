import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:text_editter/main.dart';

import 'package:text_editter/providers.dart';

void main() {
  testWidgets('main', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            initialProvider.overrideWithValue(const AsyncValue.loading()),
          ],
          child: const MyApp(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
