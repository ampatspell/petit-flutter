import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../app/typedefs.dart';
import 'doc.dart';

abstract class SnapshotStreamController<T extends HasDoc> {
  bool merge(T model, FirestoreMap map);
}

typedef ModelsStreamControllerCreate<T extends HasDoc> = T Function(
  Doc doc,
  ModelsStreamController<T> controller,
);

class ModelsStreamController<T extends HasDoc> implements SnapshotStreamController<T> {
  ModelsStreamController({
    required this.reference,
    required this.create,
  }) {
    // TODO:  StreamController.broadcast()
    _controller = StreamController<List<T>>(
      onListen: _onListen,
      onCancel: _onCancel,
    );
  }

  final ModelsStreamControllerCreate<T> create;

  final MapCollectionReference reference;
  late final StreamController<List<T>> _controller;
  StreamSubscription<MapQuerySnapshot>? _subscription;
  List<T>? _last;

  Stream<List<T>> get stream => _controller.stream;

  void _onListen() {
    _subscription = reference.snapshots(includeMetadataChanges: true).listen(_onSnapshot);
  }

  void _onCancel() {
    _subscription!.cancel();
    _last = null;
  }

  T _createWithSnapshot(MapDocumentSnapshot snapshot) {
    return create(Doc.fromSnapshot(snapshot, isOptional: true), this);
  }

  void _onSnapshot(MapQuerySnapshot snapshot) async {
    final last = _last;
    late final List<T> content;
    if (last == null) {
      content = snapshot.docs.map(_createWithSnapshot).toList(growable: false);
    } else {
      content = [...last];
      for (final change in snapshot.docChanges) {
        final type = change.type;
        final oldIndex = change.oldIndex;
        final newIndex = change.newIndex;
        final snapshot = change.doc;
        if (type == DocumentChangeType.added) {
          final model = _createWithSnapshot(snapshot);
          content.insert(newIndex, model);
        } else if (type == DocumentChangeType.modified) {
          final model = _createWithSnapshot(snapshot);
          content.removeAt(oldIndex);
          content.insert(newIndex, model);
        } else if (type == DocumentChangeType.removed) {
          content.removeAt(oldIndex);
        }
      }
    }
    _emit(content);
  }

  void _emit(List<T> models) {
    _last = models;
    _controller.add(models);
  }

  void replace(T model, FirestoreMap data) {
    final last = _last;
    if (last == null) {
      return;
    }
    final index = last.indexOf(model);
    if (index == -1) {
      return;
    }

    final doc = model.doc.copyWith(exists: true, data: data);
    final next = create(doc, this);

    final models = [...last];
    models.setRange(index, index + 1, [next]);
    _emit(models);
  }

  @override
  bool merge(T model, FirestoreMap map) {
    if (model.doc.hasNoChanges(map, false)) {
      return false;
    }
    final data = {...model.doc.data, ...map};
    replace(model, data);
    return true;
  }

  @override
  String toString() {
    return 'QuerySnapshotStreamController{path: ${reference.path}}';
  }
}
