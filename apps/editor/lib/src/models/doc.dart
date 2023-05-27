import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../app/typedefs.dart';

part 'doc.freezed.dart';

@Freezed(toStringOverride: false)
class Doc with _$Doc {
  const factory Doc({
    required MapDocumentReference reference,
    required FirestoreMap data,
    required bool exists,
    required bool isOptional,
  }) = _Doc;

  const Doc._();

  static Doc fromSnapshot(MapDocumentSnapshot snapshot, {bool isOptional = false}) {
    return Doc(
      reference: snapshot.reference,
      data: snapshot.data() ?? {},
      exists: snapshot.exists,
      isOptional: isOptional,
    );
  }

  String get id => reference.id;

  String get path => reference.path;

  dynamic operator [](String key) => data[key];

  bool hasNoChanges(FirestoreMap map, bool force) {
    if (force) {
      return false;
    }
    final current = <String, dynamic>{};
    for (final key in map.keys) {
      current[key] = data[key];
    }
    return mapEquals(current, map);
  }

  Future<void> merge(FirestoreMap map, {bool force = false}) async {
    if (hasNoChanges(map, force)) {
      return;
    }
    await reference.set(map, SetOptions(merge: true));
  }

  Future<void> set(FirestoreMap map, {bool force = false}) async {
    if (hasNoChanges(map, force) && map.keys.length == data.keys.length) {
      return;
    }
    await reference.set(map);
  }

  Future<void> delete() async {
    await reference.delete();
  }

  @override
  String toString() {
    return 'Doc{path: ${reference.path}, data: $data, exists: $exists, isOptional: $isOptional}';
  }
}

abstract class HasDoc {
  Doc get doc;
}
