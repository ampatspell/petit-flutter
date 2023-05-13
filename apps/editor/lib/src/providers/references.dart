import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/references.dart';
import 'firebase.dart';

part 'references.g.dart';

@Riverpod(keepAlive: true, dependencies: [firebaseServices])
FirestoreReferences firestoreReferences(FirestoreReferencesRef ref) {
  final services = ref.watch(firebaseServicesProvider);
  return FirestoreReferences(services);
}
