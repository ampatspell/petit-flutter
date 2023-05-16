import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'base.dart';
import 'typedefs.dart';

part 'references.freezed.dart';

@freezed
class FirestoreReferences with _$FirestoreReferences {
  const factory FirestoreReferences({
    required FirebaseServices services,
  }) = _FirestoreReferences;

  const FirestoreReferences._();

  FirebaseFirestore get _firestore => services.firestore;

  MapCollectionReference projects() {
    return _firestore.collection('projects');
  }

  MapCollectionReference projectStateCollection(MapDocumentReference projectRef) {
    return projectRef.collection('state');
  }

  MapCollectionReference projectNodesCollection(MapDocumentReference projectRef) {
    return projectRef.collection('nodes');
  }

  MapCollectionReference projectWorkspacesCollection(MapDocumentReference projectRef) {
    return projectRef.collection('workspaces');
  }

  MapCollectionReference projectWorkspaceStateCollection(MapDocumentReference workspaceRef) {
    return workspaceRef.collection('state');
  }

  MapCollectionReference projectWorkspaceItemsCollection(MapDocumentReference workspaceRef) {
    return workspaceRef.collection('items');
  }

  Doc asDoc(MapDocumentSnapshot snapshot) {
    return Doc(
      reference: snapshot.reference,
      isDeleted: !snapshot.exists,
      data: snapshot.data() ?? {},
    );
  }
}

@Freezed(toStringOverride: false)
class Doc with _$Doc {
  const factory Doc({
    required MapDocumentReference reference,
    required FirestoreMap data,
    required bool isDeleted,
  }) = _Doc;

  const Doc._();

  String get id => reference.id;

  String get path => reference.path;

  dynamic operator [](String key) => data[key];

  bool _noChanges(FirestoreMap map, bool force) {
    if (force) {
      return false;
    }
    final current = <String, dynamic>{};
    for (final key in map.keys) {
      current[key] = data[key];
    }
    return mapEquals(current, map);
  }

  Future<void> merge(FirestoreMap map, [bool force = false]) async {
    if (_noChanges(map, force)) {
      return;
    }
    await reference.set(map, SetOptions(merge: true));
  }

  Future<void> set(FirestoreMap map, [bool force = false]) async {
    if (_noChanges(map, force)) {
      return;
    }
    await reference.set(map);
  }

  Future<void> delete() async {
    await reference.delete();
  }

  @override
  String toString() {
    return 'Doc{path: ${reference.path}, data: $data}';
  }
}

abstract class HasDoc {
  Doc get doc;
}
