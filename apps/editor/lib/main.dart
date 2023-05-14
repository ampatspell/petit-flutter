import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/provider_logging_observer.dart';
import 'src/providers/base.dart';
import 'src/routes/router.dart';
import 'src/theme.dart';

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
