part of '../zug.dart';

class ModelsQuery<T extends DocumentModel> with Mountable, SnapshotSubscribable<T, MapQuerySnapshot> {
  ModelsQuery({
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
  final ObservableList<T> content = ObservableList();
  final Observable<MapQuery?> _query = Observable(null);

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
        model.mount();
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
        model.unmount();
        content.removeAt(oldIndex);
      }
    }
  }

  @override
  void _unmountContent() {
    for (final model in content) {
      model.unmount();
    }
  }

  @override
  void _mountContent() {
    for (final model in content) {
      model.mount();
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
