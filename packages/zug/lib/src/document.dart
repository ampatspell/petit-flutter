part of '../zug.dart';

class Document {
  Document({
    required MapDocumentReference reference,
    FirestoreMap? data,
  }) : this._(
          isDeleted: false,
          isNew: true,
          reference: reference,
          metadata: null,
          data: data,
          isDirty: true,
        );

  Document._({
    required this.reference,
    required bool isNew,
    required bool isDirty,
    required bool isDeleted,
    required SnapshotMetadata? metadata,
    required FirestoreMap? data,
  }) {
    _isNew.value = isNew;
    _isDirty.value = isDirty;
    _isDeleted.value = isDeleted;
    _metadata.value = metadata;
    if (data != null) {
      __data.value = ObservableMap.of(data);
    }
  }

  factory Document.fromSnapshot(MapDocumentSnapshot snapshot) {
    final reference = snapshot.reference;
    final metadata = snapshot.metadata;
    final data = snapshot.data();
    return Document._(
      reference: reference,
      data: data,
      metadata: metadata,
      isNew: false,
      isDirty: !snapshot.exists,
      isDeleted: !snapshot.exists,
    );
  }

  final MapDocumentReference reference;

  String get path => reference.path;

  String get id => reference.id;

  //

  final Observable<SnapshotMetadata?> _metadata = Observable(null, name: 'Document.metadata');

  SnapshotMetadata? get metadata => _metadata.value;

  bool? get isFromCache => metadata?.isFromCache;

  bool? get hasPendingWrites => metadata?.hasPendingWrites;

  //

  final Observable<ObservableMap<String, dynamic>> __data = Observable(
    name: 'Document.data',
    ObservableMap.of({}, name: 'Document.data.map'),
  );

  ObservableMap<String, dynamic> get _data => __data.value;

  FirestoreMap get data => UnmodifiableMapView(_data);

  //

  final Observable<bool> _isDirty = Observable(false, name: 'Document.isDirty');

  bool get isDirty => _isDirty.value;

  //

  final Observable<bool> _isNew = Observable(false, name: 'Document.isNew');

  bool get isNew => _isNew.value;

  //

  final Observable<bool> _isDeleted = Observable(false, name: 'Document.isDeleted');

  bool get isDeleted => _isDeleted.value;

  //

  dynamic operator [](String key) => _data[key];

  void operator []=(String key, dynamic value) {
    if (_data[key] == value) {
      return;
    }
    _data[key] = value;
    _isDirty.value = true;
  }

  //

  void _onUpdated({
    required FirestoreMap data,
    required SnapshotMetadata metadata,
  }) {
    __data.value = ObservableMap.of(data, name: 'Document.data.map');
    _isDirty.value = false;
    _isDeleted.value = false;
    _metadata.value = metadata;
  }

  void _onDeleted({required SnapshotMetadata metadata}) {
    _metadata.value = metadata;
    _isDeleted.value = true;
    _isDirty.value = true;
  }

  //

  Future<void>? _scheduledSave;

  Future<void> save([bool force = false]) async {
    if (!isDirty && !force) {
      return;
    }
    _scheduledSave = null;
    await reference.set(__data.value);
  }

  Future<void> delete() async {
    _scheduledSave = null;
    await reference.delete();
  }

  void scheduleSave([Duration duration = const Duration(milliseconds: 200)]) {
    late Future<void> future;
    future = Future.delayed(duration, () async {
      if (_scheduledSave != future) {
        return;
      }
      await save();
    });
    _scheduledSave = future;
  }

  //

  @override
  String toString() {
    return 'Document{path: $path, data: ${__data.value}';
  }
}
