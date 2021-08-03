import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:text_editter/providers.dart';

class Layout extends HookConsumerWidget {
  const Layout({Key? key, required Widget this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return ProviderScope(
      overrides: [
        isLargeScreenProvider.overrideWithValue(isLargeScreen),
      ],
      child: child,
    );
  }
}
