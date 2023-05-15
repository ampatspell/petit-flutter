import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';
import 'typedefs.dart';

part 'project_workspace.freezed.dart';

@freezed
class ProjectWorkspaceModel with _$ProjectWorkspaceModel {
  const factory ProjectWorkspaceModel({
    required Doc doc,
  }) = _ProjectWorkspaceModel;

  const ProjectWorkspaceModel._();

  String get name => doc['name'] as String;

  //TODO: select items not nodes
  String? get item => doc['item'] as String?;

  Future<void> delete() async {
    await doc.delete();
  }
}

@freezed
class ProjectWorkspaceItemsRepository with _$ProjectWorkspaceItemsRepository {
  const factory ProjectWorkspaceItemsRepository({
    required MapDocumentReference workspaceRef,
    required FirestoreReferences references,
  }) = _ProjectWorkspaceItemsRepository;

  const ProjectWorkspaceItemsRepository._();

  ProjectWorkspaceItemModel _asModel(MapDocumentSnapshot snapshot) {
    return ProjectWorkspaceItemModel(
      doc: references.asDoc(snapshot),
    );
  }

  List<ProjectWorkspaceItemModel> _asModels(MapQuerySnapshot snapshot) {
    return snapshot.docs.map(_asModel).toList(growable: false);
  }

  Stream<List<ProjectWorkspaceItemModel>> items() {
    return references
        .projectWorkspaceItemsCollection(workspaceRef)
        .snapshots(includeMetadataChanges: true)
        .map(_asModels);
  }
}

@freezed
class ProjectWorkspaceItemModel with _$ProjectWorkspaceItemModel {
  const factory ProjectWorkspaceItemModel({
    required Doc doc,
  }) = _ProjectWorkspaceItemModel;

  const ProjectWorkspaceItemModel._();

  int get x => doc['x'] as int;

  int get y => doc['y'] as int;

  int get pixel => doc['pixel'] as int? ?? 1;

  String get node => doc['node'] as String;

  Offset get position => Offset(x.toDouble(), y.toDouble());

  Offset renderedPosition(int pixel) {
    return position * pixel.toDouble();
  }
}
