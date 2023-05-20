import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../app/typedefs.dart';
import '../widgets/base/order.dart';
import 'base.dart';
import 'node.dart';
import 'project.dart';
import 'workspace.dart';

part 'references.freezed.dart';

@freezed
class FirestoreReferences with _$FirestoreReferences {
  const factory FirestoreReferences({
    required FirebaseServices services,
    required String? uid,
  }) = _FirestoreReferences;

  const FirestoreReferences._();

  FirebaseFirestore get _firestore => services.firestore;

  MapCollectionReference projects() {
    return _firestore.collection('projects');
  }

  MapDocumentReference projectById(String projectId) {
    return projects().doc(projectId);
  }

  MapCollectionReference projectStatesByRef(MapDocumentReference projectRef) {
    return projectRef.collection('state');
  }

  MapDocumentReference projectStateById({required String projectId}) {
    final projectRef = projectById(projectId);
    return projectStatesByRef(projectRef).doc(uid!);
  }

  MapCollectionReference projectNodesByRef(MapDocumentReference projectRef) {
    return projectRef.collection('nodes');
  }

  MapCollectionReference projectWorkspacesByRef(MapDocumentReference projectRef) {
    return projectRef.collection('workspaces');
  }

  MapDocumentReference projectWorkspaceById({required String projectId, required String workspaceId}) {
    final projectRef = projectById(projectId);
    return projectWorkspacesByRef(projectRef).doc(workspaceId);
  }

  MapCollectionReference projectWorkspaceStatesByRef(MapDocumentReference workspaceRef) {
    return workspaceRef.collection('state');
  }

  MapDocumentReference projectWorkspaceStateByRef(MapDocumentReference workspaceRef) {
    return projectWorkspaceStatesByRef(workspaceRef).doc(uid!);
  }

  MapCollectionReference projectWorkspaceItemsCollection(MapDocumentReference workspaceRef) {
    return workspaceRef.collection('items');
  }

  MapCollectionReference nodesById({required String projectId}) {
    final projectRef = projectById(projectId);
    return projectNodesByRef(projectRef);
  }

  MapCollectionReference projectWorkspaceItemsById({required String projectId, required String workspaceId}) {
    final workspaceRef = projectWorkspaceById(projectId: projectId, workspaceId: workspaceId);
    return projectWorkspaceItemsCollection(workspaceRef);
  }

  MapCollectionReference projectWorkspacesById({required String projectId}) {
    final projectRef = projectById(projectId);
    return projectWorkspacesByRef(projectRef);
  }
}

@freezed
class FirestoreStreams with _$FirestoreStreams {
  const factory FirestoreStreams({
    required FirestoreReferences references,
  }) = _FirestoreStreams;

  const FirestoreStreams._();

  Doc _asDoc(MapDocumentSnapshot snapshot, {bool isOptional = false}) {
    return Doc(
      reference: snapshot.reference,
      isDeleted: !snapshot.exists,
      isOptional: isOptional,
      data: snapshot.data() ?? {},
    );
  }

  ProjectModel _asProjectModel(MapDocumentSnapshot snapshot) {
    return ProjectModel(
      doc: _asDoc(snapshot),
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
    return ProjectStateModel(doc: _asDoc(snapshot, isOptional: true));
  }

  Stream<ProjectStateModel> projectStateById({required String projectId}) {
    return references
        .projectStateById(projectId: projectId)
        .snapshots(includeMetadataChanges: true)
        .map(_asProjectStateModel);
  }

  //

  WorkspaceModel _asProjectWorkspaceModel(MapDocumentSnapshot snapshot) {
    return WorkspaceModel(doc: _asDoc(snapshot));
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
    return WorkspaceStateModel(doc: _asDoc(snapshot, isOptional: true));
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
      return BoxNodeModel(doc: _asDoc(snapshot));
    }
    throw UnsupportedError(data.toString());
  }

  List<NodeModel> _asProjectNodeModels(QuerySnapshot<FirestoreMap> event) {
    return event.docs.map(_asProjectNodeModel).toList(growable: false);
  }

  Stream<List<NodeModel>> nodesById({required String projectId}) {
    return references.nodesById(projectId: projectId).snapshots(includeMetadataChanges: true).map(_asProjectNodeModels);
  }

  //

  WorkspaceItemModel _asProjectWorkspaceItemModel(MapDocumentSnapshot snapshot) {
    return WorkspaceItemModel(doc: _asDoc(snapshot));
  }

  List<WorkspaceItemModel> _asProjectWorkspaceItemModels(QuerySnapshot<FirestoreMap> event) {
    return event.docs.map(_asProjectWorkspaceItemModel).toList(growable: false);
  }

  Stream<List<WorkspaceItemModel>> workspaceItemsById({required String projectId, required String workspaceId}) {
    final reference = references.projectWorkspaceItemsById(projectId: projectId, workspaceId: workspaceId);
    return reference.snapshots(includeMetadataChanges: true).map(_asProjectWorkspaceItemModels);
  }

  Stream<QueryModels<WorkspaceItemModel>> workspaceItems({required String projectId, required String workspaceId}) {
    final reference = references.projectWorkspaceItemsById(projectId: projectId, workspaceId: workspaceId);
    return QuerySnapshotStreamController<WorkspaceItemModel>(
      reference: reference,
      create: (snapshot) => WorkspaceItemModel(doc: _asDoc(snapshot)),
    ).stream;
  }
}

abstract class SnapshotStreamController<T> {}

class QueryModels<T> {
  QueryModels(this._controller, this.content);

  final SnapshotStreamController<T> _controller;
  final List<T> content;

  @override
  String toString() {
    return 'QueryModels{content: $content}';
  }
}

class QuerySnapshotStreamController<T> implements SnapshotStreamController<T> {
  QuerySnapshotStreamController({
    required this.reference,
    required this.create,
  }) {
    _controller = StreamController<QueryModels<T>>(
      onListen: _onListen,
      onCancel: _onCancel,
    );
  }

  final T Function(MapDocumentSnapshot snapshot) create;

  final MapCollectionReference reference;
  late final StreamController<QueryModels<T>> _controller;
  StreamSubscription<MapQuerySnapshot>? _subscription;
  QueryModels<T>? _last;

  Stream<QueryModels<T>> get stream => _controller.stream;

  void _onListen() {
    _subscription = reference.snapshots(includeMetadataChanges: true).listen(_onSnapshot);
  }

  void _onCancel() {
    _subscription!.cancel();
    _last = null;
  }

  void _onSnapshot(MapQuerySnapshot snapshot) {
    final last = _last;
    late final List<T> content;
    if (last == null) {
      content = snapshot.docs.map(create).toList(growable: false);
    } else {
      content = [...last.content];
      for (final change in snapshot.docChanges) {
        final type = change.type;
        final oldIndex = change.oldIndex;
        final newIndex = change.newIndex;
        final doc = change.doc;
        if (type == DocumentChangeType.added) {
          final model = create(doc);
          content.insert(newIndex, model);
        } else if (type == DocumentChangeType.modified) {
          final model = create(doc);
          content.removeAt(oldIndex);
          content.insert(newIndex, model);
        } else if (type == DocumentChangeType.removed) {
          content.removeAt(oldIndex);
        }
      }
    }
    final models = QueryModels<T>(this, content);
    _last = models;
    _controller.add(models);
  }
}

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

  bool _noChanges(FirestoreMap map, bool force) {
    if (force) {
      return false;
    }
    final current = <String, dynamic>{};
    for (final key in map.keys) {
      current[key] = data[key];
    }
    return mapEquals(current, map);
  }

  Future<void> merge(FirestoreMap map, [bool force = false]) async {
    if (_noChanges(map, force)) {
      return;
    }

    await reference.set(map, SetOptions(merge: true));
  }

  Future<void> set(FirestoreMap map, [bool force = false]) async {
    if (_noChanges(map, force)) {
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
