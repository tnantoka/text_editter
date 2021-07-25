import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'note.dart';

class NoteList extends StateNotifier<List<Note>> {
  NoteList([List<Note>? notes]) : super(notes ?? []);

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();

    super.dispose();
  }

  void set(List<Note> notes) {
    state = [...notes];
  }

  void add(String name) {
    state = [
      ...state,
      Note(
        name: name,
      ),
    ];
  }

  void update({required String id, String? name, String? text}) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final prevNote = state.firstWhere((note) => note.id == id);
      final nextNote = prevNote.copyWith(
        name: name,
        text: text,
      );

      state = state.map((note) {
        if (note.id == id) {
          return nextNote;
        } else {
          return note;
        }
      }).toList();

      (await _file(id)).writeAsString(jsonEncode(nextNote));
    });
  }

  void delete(String id) async {
    state = state.where((note) => note.id != id).toList();

    final file = await _file(id);
    if (await file.exists()) {
      (await _file(id)).delete();
    }
  }

  Future<File> _file(id) async {
    return File(
        '${(await getApplicationDocumentsDirectory()).path}/notes/$id.json');
  }
}
