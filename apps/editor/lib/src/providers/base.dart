import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firebase_options.dart';
import '../app/provider_logging_observer.dart';
import '../app/utils.dart';
import '../models/base.dart';

part 'base.g.dart';

class OverrideProviderException implements Exception {
  OverrideProviderException();

  @override
  String toString() {
    return 'OverrideProviderException{}';
  }
}

@Riverpod(dependencies: [])
ProviderLoggingObserver loggingObserver(LoggingObserverRef ref) => throw UnimplementedError('override');

Future<FirebaseServices> initializeFirebase() async {
  final app = await Firebase.initializeApp(
    name: 'default',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firestore = FirebaseFirestore.instanceFor(
    app: app,
  );
  firestore.settings = firestore.settings.copyWith(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  final auth = FirebaseAuth.instanceFor(
    app: app,
  );
  return FirebaseServices(
    app: app,
    firestore: firestore,
    auth: auth,
  );
}

@Riverpod(keepAlive: true, dependencies: [])
FirebaseServices firebaseServices(FirebaseServicesRef ref) => throw UnimplementedError('override');

@Riverpod(keepAlive: true, dependencies: [firebaseServices])
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final services = ref.watch(firebaseServicesProvider);
  return services.auth.authStateChanges();
}

@Riverpod(keepAlive: true, dependencies: [authStateChanges])
class FirstAuthStateResolved extends _$FirstAuthStateResolved {
  ProviderSubscription<AsyncValue<User?>>? _subscription;

  void _close() {
    _subscription.exists((subscription) {
      subscription.close();
      _subscription = null;
    });
  }

  @override
  bool build() {
    _subscription = ref.listen(authStateChangesProvider, (previous, next) {
      if (state == false) {
        state = true;
        _close();
      }
    });
    ref.onDispose(_close);
    return false;
  }
}
