import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';

import 'src/app/provider_logging_observer.dart';
import 'src/app/router.dart';
import 'src/app/theme.dart';
import 'src/get.dart';
import 'src/providers/base.dart';

void main() async {
  mainContext.config = mainContext.config.clone(
    isSpyEnabled: true,
    readPolicy: ReactiveReadPolicy.always,
    writePolicy: ReactiveWritePolicy.always,
  );

  mainContext.spy((event) {
    debugPrint(event.toString());
  });

  WidgetsFlutterBinding.ensureInitialized();

  final firebaseServices = await initializeFirebase();
  await registerEditor(firebaseServices);

  final loggingObserver = ProviderLoggingObserver(
    enabled: false,
  );
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

class EditorApp extends ConsumerWidget {
  const EditorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoaded = ref.watch(appStateProvider.select((value) => value.isLoaded));
    if (isLoaded) {
      return FluentApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: ref.read(routerProvider),
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
