import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petit_editor/src/get_it.dart';

import 'src/area/area.dart';
import 'src/stores/app.dart';

void main() async {
  await registerGetIt();
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petit editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = it.get<App>();
    final area = useState(app.createEditorArea());
    return FutureBuilder(
      future: app.ready,
      builder: (context, snapshot) {
        return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AreaEditor(
                  area: area.value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
