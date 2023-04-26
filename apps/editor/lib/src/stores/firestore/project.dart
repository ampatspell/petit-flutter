import 'package:cloud_firestore/cloud_firestore.dart';

import '../../get_it.dart';

class Project {
  String? name;

  Project({
    required this.name,
  });

  static CollectionReference<Project> collection() {
    final FirebaseFirestore firestore = it.get();
    return Project.wrapCollection(firestore.collection('projects'));
  }

  static CollectionReference<Project> wrapCollection(CollectionReference<Map<String, dynamic>> ref) {
    return ref.withConverter(
      fromFirestore: (snapshot, options) => Project.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(options),
    );
  }

  static DocumentReference<Project> wrapReference(DocumentReference<Map<String, dynamic>> reference) {
    return reference.withConverter(
      fromFirestore: (snapshot, options) => Project.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(options),
    );
  }

  factory Project.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;
    return Project(
      name: data['name'] as String,
    );
  }

  Map<String, Object?> toFirestore(SetOptions? options) {
    return {
      'name': name,
    };
  }
}
