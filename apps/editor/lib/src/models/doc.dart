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
    required bool isDeleted,
    @Default(false) bool isOptional,
  }) = _Doc;

  const Doc._();

  String get id => reference.id;

  String get path => reference.path;

  dynamic operator [](String key) => data[key];

  bool noChanges(FirestoreMap map, bool force) {
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
    if (noChanges(map, force)) {
      return;
    }
    await reference.set(map, SetOptions(merge: true));
  }

  Future<void> set(FirestoreMap map, {bool force = false}) async {
    if (noChanges(map, force)) {
      return;
    }
    await reference.set(map);
  }

  Future<void> delete() async {
    await reference.delete();
  }

  @override
  String toString() {
    return 'Doc{path: ${reference.path}, data: $data';
  }
}

abstract class HasDoc {
  Doc get doc;
}
