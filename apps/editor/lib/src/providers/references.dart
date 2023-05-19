import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/references.dart';
import 'base.dart';

part 'references.g.dart';

@Riverpod(keepAlive: true, dependencies: [uid, firebaseServices])
FirestoreReferences firestoreReferences(FirestoreReferencesRef ref) {
  final services = ref.watch(firebaseServicesProvider);
  final uid = ref.watch(uidProvider);
  return FirestoreReferences(
    services: services,
    uid: uid,
  );
}

@Riverpod(keepAlive: true, dependencies: [firestoreReferences])
FirestoreStreams firestoreStreams(FirestoreStreamsRef ref) {
  final references = ref.watch(firestoreReferencesProvider);
  return FirestoreStreams(
    references: references,
  );
}
