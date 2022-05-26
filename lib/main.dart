import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poimemo/util/util.dart';
import 'package:poimemo/view/home_page.dart';
import 'package:poimemo/view_model/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _darkModeProvider = ref.watch(darkModeProvider);
    final _darkModeNotifier = ref.watch(darkModeProvider.notifier);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'poimemo',
      // ダークモード切替を監視
      theme: _darkModeProvider
          ? ThemeData.dark().copyWith(
              textTheme: const TextTheme(
                bodyText2: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : ThemeData.light().copyWith(
              textTheme: const TextTheme(
                bodyText2: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

      home: const HomePage(),
    );
  }
}
