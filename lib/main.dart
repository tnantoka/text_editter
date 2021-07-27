import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'widgets/home.dart';
import 'widgets/editor.dart';
import 'providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == null) {
          return null;
        }

        final split = settings.name!.split('/');

        Widget? widget;
        if (settings.name!.startsWith('/notes/') && split.length == 3) {
          widget = ProviderScope(
            overrides: [
              currentNoteIdProvider.overrideWithValue(split.last),
            ],
            child: const Editor(),
          );
        }

        if (widget == null) {
          return null;
        }

        return MaterialPageRoute<void>(builder: (context) => widget!);
      },
    );
  }
}
