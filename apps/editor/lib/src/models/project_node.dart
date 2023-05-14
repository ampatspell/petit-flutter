import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'project_node.freezed.dart';

abstract class ProjectNodeDoc {
  MapDocumentReference get reference;

  String get type;
}

@freezed
class ProjectBoxNodeDoc with _$ProjectBoxNodeDoc implements ProjectNodeDoc {
  const factory ProjectBoxNodeDoc({
    required MapDocumentReference reference,
    required FirestoreMap data,
    required bool isDeleted,
  }) = _ProjectBoxNodeDoc;

  const ProjectBoxNodeDoc._();

  @override
  String get type => data['type'] as String;
}
