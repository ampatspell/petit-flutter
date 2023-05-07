import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'project.freezed.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required MapDocumentReference reference,
    required FirestoreMap data,
  }) = _Project;
}
