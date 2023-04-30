import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'base.dart';
import 'entity.dart';
import 'hook.dart';

part 'query_array.g.dart';

class FirestoreModels<M extends FirestoreEntity> extends _FirestoreModels<M> with _$FirestoreModels {
  FirestoreModels({
    required super.reference,
    required super.model,
    required super.canUpdate,
  });

  @override
  String toString() {
    return 'FirestoreModels{isLoading: $isLoading, content: $content';
  }
}

abstract class _FirestoreModels<M extends FirestoreEntity> extends FirestoreModelsBase<M, QuerySnapshot<FirestoreData>>
    with Store {
  final Query<Map<String, dynamic>> reference;
  final ObservableList<M> content = ObservableList();

  _FirestoreModels({
    required this.reference,
    required FirestoreEntityFactory<M> model,
    required CanUpdateFirestoreEntity<M>? canUpdate,
  }) : super(
          subscribe: () => reference.snapshots(includeMetadataChanges: true),
          model: model,
          canUpdate: canUpdate,
        );

  @computed
  String get asString {
    return toString();
  }

  @override
  void onRefresh() {
    content.clear();
  }

  @override
  void onSnapshot(QuerySnapshot<FirestoreData> querySnapshot) {
    for (var change in querySnapshot.docChanges) {
      final snapshot = change.doc;
      final reference = snapshot.reference;
      final oldIndex = change.oldIndex;
      final newIndex = change.newIndex;
      final data = snapshot.data();
      switch (change.type) {
        case DocumentChangeType.added:
          final model = this.model(reference)..onSnapshot(snapshot, data!);
          content.insert(newIndex, model);
          break;
        case DocumentChangeType.removed:
          final model = content[oldIndex];
          model.onDeleted(snapshot);
          content.removeAt(oldIndex);
          break;
        case DocumentChangeType.modified:
          var model = content[oldIndex];
          if (canUpdate != null && !canUpdate!(model, snapshot, data)) {
            model = this.model(reference)..onSnapshot(snapshot, data!);
            if (oldIndex == newIndex) {
              content[oldIndex] = model;
            }
          } else {
            model.onSnapshot(snapshot, data!);
          }
          if (oldIndex != newIndex) {
            content.removeAt(oldIndex);
            content.insert(newIndex, model);
          }
          break;
      }
    }
    isFromCache = querySnapshot.metadata.isFromCache;
    hasPendingWrites = querySnapshot.metadata.hasPendingWrites;
    isLoading = false;
  }

  void updateReference(Query<Map<String, dynamic>> reference) {
    replaceStream(() => reference.snapshots(includeMetadataChanges: true));
  }
}

FirestoreModels<M> useModels<M extends FirestoreEntity>(
    {required Query<FirestoreData> query,
    required FirestoreEntityFactory<M> model,
    CanUpdateFirestoreEntity<M>? canUpdate}) {
  return useSubscribable(
    model: FirestoreModels(
      reference: query,
      model: model,
      canUpdate: canUpdate,
    ),
    update: (FirestoreModels state, FirestoreModels created) {
      state.updateReference(created.reference);
    },
  );
}
