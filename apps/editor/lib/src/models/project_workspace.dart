import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'project_workspace.freezed.dart';

@freezed
class ProjectWorkspaceDoc with _$ProjectWorkspaceDoc {
  const ProjectWorkspaceDoc._();

  const factory ProjectWorkspaceDoc({
    required MapDocumentReference reference,
    required FirestoreMap data,
    required bool isDeleted,
  }) = _ProjectWorkspaceDoc;

  String get name => data['name'] as String;

  Future<void> touch() async {
    await reference.set({
      'foo': DateTime.now(),
    }, SetOptions(merge: true));
  }

  Future<void> delete() async {
    await reference.delete();
  }
}
