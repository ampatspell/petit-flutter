import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'typedefs.dart';

part 'project.freezed.dart';

@freezed
class ProjectDoc with _$ProjectDoc {
  const ProjectDoc._();

  const factory ProjectDoc({
    required MapDocumentReference reference,
    required bool isDeleted,
    required FirestoreMap data,
  }) = _ProjectDoc;

  String get name => data['name'] as String;

  String? get workspace => data['workspace'] as String?;

  String? get node => data['node'] as String?;

  Future<void> updateWorkspaceId(String? id) async {
    await reference.set({
      'workspace': id,
    }, SetOptions(merge: true));
  }

  Future<void> updateNodeId(String? id) async {
    await reference.set({
      'node': id,
    }, SetOptions(merge: true));
  }

  Future<void> delete() async {
    await reference.delete();
  }
}
