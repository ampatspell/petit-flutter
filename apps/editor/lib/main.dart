import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:petit_editor/src/theme.dart';

import 'src/routes/router.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MacosApp.router(
    //   routerDelegate: router.routerDelegate,
    //   routeInformationParser: router.routeInformationParser,
    //   routeInformationProvider: router.routeInformationProvider,
    //   theme: MacosThemeData.light(),
    //   darkTheme: MacosThemeData.dark(),
    //   themeMode: ThemeMode.system,
    //   debugShowCheckedModeBanner: false,
    // );
    return MaterialApp.router(
      title: 'Petit editor',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: router,
    );
  }
}
