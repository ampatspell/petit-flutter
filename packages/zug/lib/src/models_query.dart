part of '../zug.dart';

class ModelsQuery<T extends DocumentModel> with Mountable, SnapshotSubscribable<T, MapQuerySnapshot, MapQuery> {
  ModelsQuery({
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

  final ObservableList<T> content = ObservableList(name: 'ModelsQuery.content');

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
    for (final change in snapshot.docChanges) {
      final type = change.type;
      final oldIndex = change.oldIndex;
      final newIndex = change.newIndex;
      final doc = change.doc;
      final data = doc.data();
      final metadata = doc.metadata;
      if (type == DocumentChangeType.added) {
        final model = create(Document.fromSnapshot(doc));
        content.insert(newIndex, model);
        model._mount();
      } else if (type == DocumentChangeType.modified) {
        final current = content[oldIndex];
        current.doc._onUpdated(data: data!, metadata: metadata);
        if (oldIndex != newIndex) {
          content.removeAt(oldIndex);
          content.insert(newIndex, current);
        }
      } else if (type == DocumentChangeType.removed) {
        final model = content[oldIndex];
        model.doc._onDeleted(metadata: metadata);
        model._unmount();
        content.removeAt(oldIndex);
      }
    }
  }

  @override
  void _unmountContent() {
    for (final model in content) {
      model._unmount();
    }
  }

  @override
  void _mountContent() {
    for (final model in content) {
      model._mount();
    }
  }

  @override
  void _clearContent() {
    content.clear();
  }

  @override
  String toString() {
    return 'ModelsQuery{name: $name}';
  }
}
