part of '../zug.dart';

class ModelQuery<T extends DocumentModel> with Mountable, SnapshotSubscribable<T, MapQuerySnapshot> {
  ModelQuery({
    this.name,
    required this.create,
    MapQuery? query,
  }) {
    this.query = query;
  }

  final String? name;

  @override
  Iterable<Mountable> get mountable => [];

  final CreateModel<T> create;
  final Observable<T?> _content = Observable(null);
  final Observable<MapQuery?> _query = Observable(null);

  T? get content => _content.value;

  MapQuery? get query {
    return _query.value;
  }

  set query(MapQuery? query) {
    runInAction(() {
      _streamProvider = query != null ? () => query.snapshots(includeMetadataChanges: false) : null;
      _query.value = query;
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
  void _onSnapshot(MapQuerySnapshot snapshot) {
    final current = _content.value;
    if (snapshot.docs.isNotEmpty) {
      final first = snapshot.docs[0];
      if (current != null) {
        if (current.doc.reference == first.reference) {
          current.doc._onUpdated(data: first.data(), metadata: first.metadata);
        } else {
          current.unmount();
          final model = create(Document.fromSnapshot(first));
          _content.value = model;
        }
      } else {
        final model = create(Document.fromSnapshot(first));
        _content.value = model;
      }
    } else {
      if (current != null) {
        current.unmount();
      }
      _content.value = null;
    }
  }

  @override
  void _clearContent() {
    _content.value = null;
  }

  @override
  void _unmountContent() {
    _content.value?.unmount();
  }

  @override
  void _mountContent() {
    _content.value?.mount();
  }

  @override
  String toString() {
    return 'ModelQuery{name: $name}';
  }
}
