import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/base.dart';
import '../models/references.dart';
import '../models/streams.dart';

part 'base.g.dart';

@Deprecated('use mobx')
class OverrideProviderException implements Exception {
  OverrideProviderException() {
    if (kDebugMode) {
      print(StackTrace.current);
    }
  }

  @override
  String toString() {
    return 'OverrideProviderException{}';
  }
}

@Deprecated('use mobx')
@Riverpod(keepAlive: true, dependencies: [])
FirebaseServices firebaseServices(FirebaseServicesRef ref) => throw UnimplementedError('override');

@Deprecated('use mobx')
@Riverpod(keepAlive: true, dependencies: [firebaseServices])
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final services = ref.watch(firebaseServicesProvider);
  return services.auth.authStateChanges();
}

@Deprecated('use mobx')
@Riverpod(keepAlive: true, dependencies: [authStateChanges])
AppState appState(AppStateRef ref) {
  final subscription = ref.listen(authStateChangesProvider, (previous, next) {
    ref.state = ref.state.copyWith(user: next.value, isLoaded: true);
  });
  ref.onDispose(subscription.close);

  final user = ref.read(authStateChangesProvider).value;
  return AppState(user: user);
}

@Deprecated('use mobx')
@Riverpod(keepAlive: true, dependencies: [appState])
String? uid(UidRef ref) {
  return ref.watch(appStateProvider.select((value) => value.user?.uid));
}

@Deprecated('use mobx')
@Riverpod(keepAlive: true, dependencies: [uid, firebaseServices])
FirestoreReferences firestoreReferences(FirestoreReferencesRef ref) {
  final services = ref.watch(firebaseServicesProvider);
  final uid = ref.watch(uidProvider);
  return FirestoreReferences(
    services: services,
    uid: uid,
  );
}

@Deprecated('use mobx')
@Riverpod(keepAlive: true, dependencies: [firestoreReferences])
FirestoreStreams firestoreStreams(FirestoreStreamsRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  return FirestoreStreams(
    references: references,
  );
}
