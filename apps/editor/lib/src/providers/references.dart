import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petit_editor/src/models/app.dart';
import 'package:petit_editor/src/providers/app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../typedefs.dart';

part 'references.g.dart';

class FirestoreReferences {
  final FirebaseServices _services;

  FirestoreReferences(FirebaseServices services) : _services = services;

  FirebaseFirestore get _firestore => _services.firestore;

  MapCollectionReference get projects {
    return _firestore.collection('projects');
  }

  MapQuery get sortedProjects {
    return projects.orderBy('name');
  }

  @override
  String toString() {
    return 'FirestoreReferences{}';
  }
}

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
