import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'project_node.freezed.dart';

abstract class ProjectNode {}

@freezed
class ProjectBoxNode with _$ProjectBoxNode implements ProjectNode {
  const ProjectBoxNode._();

  const factory ProjectBoxNode({
    required MapDocumentReference reference,
    required FirestoreMap data,
  }) = _ProjectBoxNode;
}
