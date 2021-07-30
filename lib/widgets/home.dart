import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../providers.dart';

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteList = ref.watch(noteListProvider);
    final scrollController = useScrollController();
    final initial = ref.watch(initialProvider);

    final BannerAd banner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/2934735716',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
    banner.load();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.info_outlined),
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: 'Text Editter',
            );
          },
        ),
      ),
      body: initial.when(
        data: (_) => Column(
          children: [
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  for (var i = 0; i < noteList.length; i++) ...[
                    Dismissible(
                      key: ValueKey(noteList[i].id),
                      onDismissed: (_) {
                        ref
                            .read(noteListProvider.notifier)
                            .delete(noteList[i].id);
                      },
                      child: ListTile(
                        title: Text(noteList[i].name),
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/notes/${noteList[i].id}');
                        },
                      ),
                    ),
                    const Divider(height: 0),
                  ],
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: AdWidget(ad: banner),
              width: banner.size.width.toDouble(),
              height: banner.size.height.toDouble(),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) {},
      ),
      floatingActionButton: initial.when(
        data: (_) => Container(
          margin: EdgeInsets.only(bottom: banner.size.height.toDouble()),
          child: FloatingActionButton(
            onPressed: () {
              ref.read(noteListProvider.notifier).add('Untitled');

              WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
              });
            },
            child: const Icon(Icons.add),
          ),
        ),
        loading: () => null,
        error: (err, stack) => null,
      ),
    );
  }
}
