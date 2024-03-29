part of '../zug.dart';

class ModelReference<T extends DocumentModel>
    with Mountable, SnapshotSubscribable<T, MapDocumentSnapshot, MapDocumentReference> {
  ModelReference({
    this.name,
    required this.create,
    MapDocumentReferenceProvider reference,
  }) {
    this._referenceProvider = reference;
  }

  @override
  Iterable<Mountable> get mountable => [];

  final String? name;
  final CreateModel<T> create;

  //

  final Observable<T?> _content = Observable(null, name: 'ModelReference.content');

  T? get content => _content.value;

  @override
  bool get isMissing {
    final content = this.content;
    if (content == null) {
      return true;
    }
    return content.doc.isDeleted;
  }

  //

  MapDocumentReference? get reference => _streamSource;

  set reference(MapDocumentReference? reference) {
    _referenceProvider = () => reference;
  }

  set _referenceProvider(MapDocumentReferenceProvider provider) {
    _streamProvider = () => StreamAndSource.fromDocumentReferenceProvider(provider);
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
          current.mount();
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
