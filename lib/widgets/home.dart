import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:text_editter/providers.dart';
import 'package:text_editter/widgets/editor.dart';

import 'notes.dart';
import 'editor.dart';

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLargeScreen = ref.watch(isLargeScreenProvider);

    return isLargeScreen
        ? Row(
            children: [
              Expanded(
                flex: 1,
                child: Notes(),
              ),
              Expanded(
                flex: 2,
                child: Editor(),
              ),
            ],
          )
        : Notes();
  }
}
