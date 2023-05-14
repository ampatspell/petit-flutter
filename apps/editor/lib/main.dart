import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petit_editor/src/models/base.dart';
import 'package:petit_editor/src/providers/firebase.dart';
import 'package:petit_editor/src/theme.dart';

import 'src/provider_logging_observer.dart';
import 'src/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseServices = await initializeFirebase();
  final loggingObserver = ProviderLoggingObserver(enabled: false);
  runApp(ProviderScope(
    overrides: [
      loggingObserverProvider.overrideWithValue(loggingObserver),
      firebaseServicesProvider.overrideWithValue(firebaseServices),
    ],
    observers: [
      loggingObserver,
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
