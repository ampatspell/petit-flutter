import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petit_editor/src/stores/firestore/utils.dart';

import '../../get_it.dart';

class ProjectData {
  String? name;
  FirestoreDateTime createdAt;

  @override
  String toString() {
    return 'ProjectData{name: $name}';
  }

  ProjectData({required this.name, required this.createdAt});

  static CollectionReference<ProjectData> collection() {
    final FirebaseFirestore firestore = it.get();
    return ProjectData.wrapCollection(firestore.collection('projects'));
  }

  static DocumentReference<ProjectData> doc(String id) {
    return collection().doc(id);
  }

  static CollectionReference<ProjectData> wrapCollection(CollectionReference<Map<String, dynamic>> ref) {
    return ref.withConverter(
      fromFirestore: (snapshot, options) => ProjectData.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(options),
    );
  }

  static DocumentReference<ProjectData> wrapReference(DocumentReference<Map<String, dynamic>> reference) {
    return reference.withConverter(
      fromFirestore: (snapshot, options) => ProjectData.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(options),
    );
  }

  factory ProjectData.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;
    return ProjectData(
      name: data['name'] as String,
      createdAt: FirestoreDateTime.fromFirestore(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore(SetOptions? options) {
    return {
      'name': name,
      'createdAt': createdAt.toFirestore(),
    };
  }
}
