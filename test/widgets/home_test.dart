import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:text_editter/widgets/home.dart';
import 'package:text_editter/providers.dart';
import 'package:text_editter/note_list.dart';
import 'package:text_editter/note.dart';

void main() {
  testWidgets('Home', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            noteListProvider.overrideWithValue(
              NoteList([
                Note(name: 'note-0'),
                Note(name: 'note-1'),
              ]),
            ),
            initialProvider.overrideWithValue(const AsyncValue.data(true)),
          ],
          child: const Home(),
        ),
      ),
    );

    expect(find.text('note-0'), findsOneWidget);
    expect(find.text('note-1'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    expect(find.text('Untitled'), findsOneWidget);

    await tester.drag(find.text('note-0'), const Offset(1000, 0));
    await tester.pumpAndSettle();
    expect(find.text('note-0'), findsNothing);
  });
}
