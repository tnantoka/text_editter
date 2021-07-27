import 'dart:io';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import 'note_list.dart';
import 'note.dart';

final noteListProvider =
    StateNotifierProvider<NoteList, List<Note>>((ref) => NoteList());

final initialProvider = FutureProvider<bool>((ref) async {
  final directory =
      Directory('${(await getApplicationDocumentsDirectory()).path}/notes');
  await directory.create();

  final List<Note> notes = [];
  await for (final item in directory.list()) {
    if (!item.path.endsWith('.json')) {
      continue;
    }

    final jsonString = await File(item.path).readAsString();
    Map<String, dynamic> noteMap = jsonDecode(jsonString);
    final note = Note.fromJson(noteMap);

    notes.add(note);
  }

  notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));

  ref.read(noteListProvider.notifier).set(notes);

  await AppTrackingTransparency.requestTrackingAuthorization();

  return true;
});

final currentNoteIdProvider =
    Provider<String>((ref) => throw UnimplementedError());
