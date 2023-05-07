import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app.dart';
import '../typedefs.dart';

class FirestoreReferences {
  final FirebaseServicesData _services;

  FirestoreReferences(FirebaseServicesData services) : _services = services;

  FirebaseFirestore get _firestore => _services.firestore;

  MapCollectionReference get projects {
    return _firestore.collection('projects');
  }

  @override
  String toString() {
    return 'FirestoreReferences{}';
  }
}
