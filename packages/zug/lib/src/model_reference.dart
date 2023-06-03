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
        } else {
          current.doc._onDeleted(metadata: snapshot.metadata);
          current._unmount();
        }
      } else {
        current._unmount();
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
    _content.value?._mount();
  }

  @override
  void _unmountContent() {
    _content.value?._unmount();
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
