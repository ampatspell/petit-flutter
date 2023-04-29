import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'base.dart';

part 'entity.g.dart';

class FirestoreEntity extends _FirestoreEntity with _$FirestoreEntity {
  FirestoreEntity(super.reference);
}

abstract class _FirestoreEntity with Store {
  final DocumentReference<FirestoreData> reference;

  @observable
  bool? isFromCache;

  @observable
  bool? hasPendingWrites;

  @observable
  bool isLoaded = false;

  @observable
  bool isNew = true;

  @observable
  bool isDeleted = false;

  @observable
  bool isSaving = false;

  @observable
  ObservableMap<String, dynamic> data = ObservableMap();

  _FirestoreEntity(this.reference);

  _setState({
    required DocumentSnapshot<FirestoreData> snapshot,
    bool? isNew,
    bool? isLoaded,
    bool? isDeleted,
  }) {
    isFromCache = snapshot.metadata.isFromCache;
    hasPendingWrites = snapshot.metadata.hasPendingWrites;
    if (isNew != null) {
      this.isNew = isNew;
    }
    if (isLoaded != null) {
      this.isLoaded = isLoaded;
    }
    if (isDeleted != null) {
      this.isDeleted = isDeleted;
    }
  }

  @action
  void onSnapshot(DocumentSnapshot<FirestoreData> snapshot, FirestoreData newData) {
    _setState(
      snapshot: snapshot,
      isNew: false,
      isLoaded: true,
      isDeleted: false,
    );
    data = ObservableMap.of(newData);
  }

  @action
  void onDeleted(DocumentSnapshot<FirestoreData> snapshot) {
    _setState(
      snapshot: snapshot,
      isNew: false,
      isDeleted: true,
    );
  }

  @action
  void set(FirestoreData data) {
    this.data = ObservableMap.of(data);
  }

  Map<String, dynamic> toFirestore() {
    return data.nonObservableInner;
  }

  @action
  Future<void> _withSaving(Future<void> Function() cb) async {
    isSaving = true;
    try {
      await cb();
    } finally {
      isSaving = false;
    }
  }

  Future<void> save() async {
    await _withSaving(() async {
      final data = toFirestore();
      await reference.set(data);
    });
  }

  Future<void> delete() async {
    await _withSaving(() async {
      await reference.delete();
    });
  }
}
