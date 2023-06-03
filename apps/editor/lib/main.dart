import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import 'src/app/router.dart';
import 'src/app/theme.dart';
import 'src/get.dart';
import 'src/mobx/mobx.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  mainContext.config = mainContext.config.clone(
    isSpyEnabled: false,
    readPolicy: ReactiveReadPolicy.always,
    writePolicy: ReactiveWritePolicy.always,
  );
  mainContext.spy((event) => debugPrint(event.toString()));
  await registerEditor();
  runApp(const EditorApp());
}

class EditorApp extends StatelessObserverWidget {
  const EditorApp({super.key});

  Auth get _auth => it.get();

  @override
  Widget build(BuildContext context) {
    final isLoaded = _auth.isLoaded;
    if (isLoaded) {
      return FluentApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: theme,
      );
    } else {
      return FluentApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const NavigationView(
          content: Center(
            child: Text('Loading…'),
          ),
        ),
      );
    }
  }
}
