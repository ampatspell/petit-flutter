import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'project_workspace.freezed.dart';

@freezed
class ProjectWorkspace with _$ProjectWorkspace {
  const ProjectWorkspace._();

  const factory ProjectWorkspace({
    required MapDocumentReference reference,
    required FirestoreMap data,
  }) = _ProjectWorkspace;
}
