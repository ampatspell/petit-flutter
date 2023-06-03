import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zug/zug.dart';

import '../widgets/base/order.dart';
import 'controllers.dart';
import 'doc.dart';
import 'node.dart';
import 'project.dart';
import 'references.dart';
import 'workspace.dart';

part 'streams.freezed.dart';

@freezed
class FirestoreStreams with _$FirestoreStreams {
  const factory FirestoreStreams({
    required FirestoreReferences references,
  }) = _FirestoreStreams;

  const FirestoreStreams._();

  ProjectModel _asProjectModel(MapDocumentSnapshot snapshot) {
    return ProjectModel(
      doc: Doc.fromSnapshot(snapshot),
    );
  }

  List<ProjectModel> _asProjectModels(MapQuerySnapshot event) {
    return event.docs.map(_asProjectModel).toList(growable: false);
  }

  Stream<List<ProjectModel>> projects({required OrderDirection order}) {
    return references
        .projects()
        .orderBy('name', descending: order.isDescending)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectModels);
  }

  Stream<ProjectModel> projectById({required String projectId}) {
    return references.projectById(projectId).snapshots(includeMetadataChanges: true).map(_asProjectModel);
  }

  //

  ProjectStateModel _asProjectStateModel(MapDocumentSnapshot snapshot) {
    return ProjectStateModel(doc: Doc.fromSnapshot(snapshot, isOptional: true));
  }

  Stream<ProjectStateModel> projectStateById({required String projectId}) {
    return references
        .projectStateById(projectId: projectId)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectStateModel);
  }

  //

  WorkspaceModel _asProjectWorkspaceModel(MapDocumentSnapshot snapshot) {
    return WorkspaceModel(doc: Doc.fromSnapshot(snapshot));
  }

  List<WorkspaceModel> _asProjectWorkspaceModels(MapQuerySnapshot snapshot) {
    return snapshot.docs.map(_asProjectWorkspaceModel).toList(growable: false);
  }

  Stream<List<WorkspaceModel>> workspacesById(String projectId) {
    return references
        .projectWorkspacesById(projectId: projectId)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectWorkspaceModels);
  }

  Stream<WorkspaceModel> workspaceById({required String projectId, required String workspaceId}) {
    final workspaceRef = references.projectWorkspaceById(projectId: projectId, workspaceId: workspaceId);
    return workspaceRef.snapshots(includeMetadataChanges: true).map(_asProjectWorkspaceModel);
  }

  //

  WorkspaceStateModel _asProjectWorkspaceStateModel(MapDocumentSnapshot snapshot) {
    return WorkspaceStateModel(doc: Doc.fromSnapshot(snapshot, isOptional: true));
  }

  Stream<WorkspaceStateModel> workspaceStateById({required String projectId, required String workspaceId}) {
    final workspaceRef = references.projectWorkspaceById(projectId: projectId, workspaceId: workspaceId);
    return references
        .projectWorkspaceStateByRef(workspaceRef)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectWorkspaceStateModel);
  }

  //

  NodeModel _asProjectNodeModel(MapDocumentSnapshot snapshot) {
    final data = snapshot.data()!;
    final type = data['type'] as String;
    if (type == 'box') {
      return BoxNodeModel(doc: Doc.fromSnapshot(snapshot));
    }
    throw UnsupportedError(data.toString());
  }

  List<NodeModel> _asProjectNodeModels(MapQuerySnapshot event) {
    return event.docs.map(_asProjectNodeModel).toList(growable: false);
  }

  Stream<List<NodeModel>> nodesById({required String projectId}) {
    return references.nodesById(projectId: projectId).snapshots(includeMetadataChanges: true).map(_asProjectNodeModels);
  }

  //

  Stream<List<T>> modelsStream<T extends HasDoc>({
    required MapQuery reference,
    required ModelsStreamControllerCreate<T> create,
  }) {
    final controller = ModelsStreamController<T>(
      reference: reference,
      create: create,
    );
    return controller.stream;
  }

  Stream<List<WorkspaceItemModel>> workspaceItemsById({required String projectId, required String workspaceId}) {
    final reference = references
        .projectWorkspaceItemsById(
          projectId: projectId,
          workspaceId: workspaceId,
        )
        .orderBy('index');

    return modelsStream(
      reference: reference,
      create: (doc, controller) => WorkspaceItemModel(
        doc: doc,
        controller: controller,
      ),
    );
  }
}
