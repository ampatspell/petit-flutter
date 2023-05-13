import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'project_node.freezed.dart';

abstract class ProjectNodeDoc {}

@freezed
class ProjectBoxNodeDoc with _$ProjectBoxNodeDoc implements ProjectNodeDoc {
  const ProjectBoxNodeDoc._();

  const factory ProjectBoxNodeDoc({
    required MapDocumentReference reference,
    required FirestoreMap data,
    required bool isDeleted,
  }) = _ProjectBoxNodeDoc;
}
