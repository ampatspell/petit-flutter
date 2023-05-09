import 'package:petit_editor/src/providers/firebase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/references.dart';

part 'references.g.dart';

@Riverpod(keepAlive: true, dependencies: [firebaseServices])
FirestoreReferences firestoreReferences(FirestoreReferencesRef ref) {
  final services = ref.watch(firebaseServicesProvider);
  return FirestoreReferences(services);
}

// return Rx.combineLatest2(
//   database.accountStream(),
//   database.connectionsStream(),
//   (Account account, List<Connections> connections) {
//     connections.forEach((connection) {
//       account.connections.add(connection.documentId);
//     });
//     return account;
//   },
// );
