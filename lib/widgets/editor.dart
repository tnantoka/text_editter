import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../providers.dart';

class Editor extends HookConsumerWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteList = ref.read(noteListProvider);
    final noteId = ref.read(currentNoteIdProvider);
    final note = noteList.firstWhere((note) => note.id == noteId);

    final nameController = useTextEditingController();
    nameController.text = note.name;

    final textController = useTextEditingController();
    textController.text = note.text;

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            initialValue: '',
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              ref.read(noteListProvider.notifier).delete(note.id);
              Navigator.pop(context);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                child: Text('Delete'),
                value: 'delete',
              )
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 4),
                hintText: 'Note name',
              ),
              controller: nameController,
              onChanged: (nextName) {
                ref
                    .read(noteListProvider.notifier)
                    .update(id: noteId, name: nextName);
              },
            ),
            TextField(
              maxLines: null,
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
                hintText: 'Note content',
              ),
              controller: textController,
              onChanged: (nextText) {
                ref
                    .read(noteListProvider.notifier)
                    .update(id: noteId, text: nextText);
              },
            )
          ],
        ),
      ),
    );
  }
}
