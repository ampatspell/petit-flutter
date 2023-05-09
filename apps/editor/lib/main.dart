import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/providers/firebase.dart';
import 'package:petit_editor/src/theme.dart';

import 'src/logging.dart';
import 'src/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseServices = await initializeFirebase();
  runApp(ProviderScope(
    overrides: [
      firebaseServicesProvider.overrideWithValue(firebaseServices),
    ],
    observers: [
      LoggingObserver(),
    ],
    child: const EditorApp(),
  ));
}

class EditorApp extends StatelessWidget {
  const EditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: theme,
    );
  }
}
