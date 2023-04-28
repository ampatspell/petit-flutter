import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:petit_editor/src/get_it.dart';
import 'package:petit_editor/src/theme.dart';

import 'src/routes/router.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getItReady,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FluentApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            theme: FluentThemeData.light(),
          );

          // return MacosApp.router(
          //   routerDelegate: router.routerDelegate,
          //   routeInformationParser: router.routeInformationParser,
          //   routeInformationProvider: router.routeInformationProvider,
          //   theme: MacosThemeData.light(),
          //   themeMode: ThemeMode.light,
          //   debugShowCheckedModeBanner: false,
          // );
        } else {
          return Container();
        }
      },
    );
  }
}
