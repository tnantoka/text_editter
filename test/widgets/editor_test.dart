import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:text_editter/widgets/editor.dart';
import 'package:text_editter/providers.dart';
import 'package:text_editter/note_list.dart';
import 'package:text_editter/note.dart';

void main() {
  testWidgets('Editor', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            noteListProvider.overrideWithValue(
              NoteList([
                Note(id: 'id-0', name: 'note-0', text: 'text-0'),
                Note(id: 'id-1', name: 'note-1', text: 'text-1'),
              ]),
            ),
            currentNoteIdProvider.overrideWithValue(StateController('id-0')),
            isLargeScreenProvider.overrideWithValue(false),
          ],
          child: const Editor(),
        ),
      ),
    );

    expect(find.text('note-0'), findsOneWidget);
    expect(find.text('text-0'), findsOneWidget);

    await tester.tap(find.text('note-0'));
    tester.testTextInput.enterText('note-0-edited');
    await tester.pump();

    await tester.tap(find.text('text-0'));
    tester.testTextInput.enterText('text-0-edited');
    await tester.pump();

    expect(find.text('note-0-edited'), findsOneWidget);
    expect(find.text('text-0-edited'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete', skipOffstage: false));
    await tester.pumpAndSettle();

    expect(find.text('note-0-edited'), findsNothing);
    expect(find.text('text-0-edited'), findsNothing);
  });
}
