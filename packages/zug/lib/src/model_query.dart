part of '../zug.dart';

class ModelQuery<T extends DocumentModel> with Mountable, SnapshotSubscribable<T, MapQuerySnapshot, MapQuery> {
  ModelQuery({
    this.name,
    required this.create,
    MapQueryProvider? query,
  }) {
    this._queryProvider = query;
  }

  @override
  Iterable<Mountable> get mountable => [];

  final String? name;
  final CreateModel<T> create;

  //

  final Observable<T?> _content = Observable(null, name: 'ModelQuery.content');

  T? get content => _content.value;

  @override
  bool get isMissing => content == null;

  //

  MapQuery? get query => _streamSource;

  set query(MapQuery? query) => _queryProvider = () => query;

  set _queryProvider(MapQueryProvider provider) {
    _streamProvider = () => StreamAndSource.fromQueryProvider(provider);
  }

  //

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
