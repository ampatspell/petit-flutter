part of '../zug.dart';

class ModelReference<T extends DocumentModel> with Mountable, SnapshotSubscribable<T, MapDocumentSnapshot> {
  ModelReference({
    this.name,
    required this.create,
    MapDocumentReference? reference,
  }) {
    this.reference = reference;
  }

  final String? name;

  @override
  Iterable<Mountable> get mountable => [];

  final CreateModel<T> create;
  final Observable<MapDocumentReference?> _reference = Observable(null);
  final Observable<T?> _content = Observable(null);

  T? get content => _content.value;

  MapDocumentReference? get reference {
    return _reference.value;
  }

  set reference(MapDocumentReference? reference) {
    runInAction(() {
      _reference.value = reference;
      _streamProvider = reference != null ? () => reference.snapshots(includeMetadataChanges: false) : null;
    });
  }

  @override
  void onMounted() {
    super.onMounted();
    _onMounted();
  }

  @override
  void onUnmounted() {
    super.onUnmounted();
    _onUnmounted();
  }

  @override
  void _onSnapshot(MapDocumentSnapshot snapshot) {
    final current = _content.value;
    if (current != null) {
      if (current.doc.reference == snapshot.reference) {
        if (snapshot.exists) {
          current.doc._onUpdated(data: snapshot.data()!, metadata: snapshot.metadata);
        } else {
          current.doc._onDeleted(metadata: snapshot.metadata);
          current.unmount();
        }
      } else {
        current.unmount();
        final model = create(Document.fromSnapshot(snapshot));
        _content.value = model;
      }
    } else {
      final model = create(Document.fromSnapshot(snapshot));
      _content.value = model;
    }
  }

  @override
  void _mountContent() {
    _content.value?.mount();
  }

  @override
  void _unmountContent() {
    _content.value?.unmount();
  }

  @override
  void _clearContent() {
    _content.value = null;
  }

  @override
  String toString() {
    return 'ModelReference{name: $name}';
  }
}
