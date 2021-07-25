import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../providers.dart';

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteList = ref.watch(noteListProvider);
    final scrollController = useScrollController();
    final initial = ref.read(initialProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: initial.when(
        data: (_) => ListView(
          controller: scrollController,
          children: [
            for (var i = 0; i < noteList.length; i++) ...[
              Dismissible(
                key: ValueKey(noteList[i].id),
                onDismissed: (_) {
                  ref.read(noteListProvider.notifier).delete(noteList[i].id);
                },
                child: ListTile(
                  title: Text(noteList[i].name),
                  onTap: () {
                    Navigator.pushNamed(context, '/notes/${noteList[i].id}');
                  },
                ),
              ),
              const Divider(height: 0),
            ],
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) {},
      ),
      floatingActionButton: initial.when(
        data: (_) => FloatingActionButton(
          onPressed: () {
            ref.read(noteListProvider.notifier).add('Untitled');

            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            });
          },
          child: const Icon(Icons.add),
        ),
        loading: () => null,
        error: (err, stack) => null,
      ),
    );
  }
}
