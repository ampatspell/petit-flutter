import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'base.dart';
import 'entity.dart';
import 'hook.dart';

part 'query_array.g.dart';

class FirestoreQueryLoader<M extends FirestoreEntity> extends _FirestoreQueryLoader<M> with _$FirestoreQueryLoader {
  FirestoreQueryLoader({
    required super.reference,
    required super.model,
    required super.canUpdate,
  });

  @override
  String toString() {
    return 'FirestoreQueryLoader{isLoading: $isLoading, content: $content';
  }
}

abstract class _FirestoreQueryLoader<M extends FirestoreEntity>
    extends FirestoreModelsBase<M, QuerySnapshot<FirestoreData>> with Store {
  final Query<Map<String, dynamic>> reference;
  final ObservableList<M> content = ObservableList();

  _FirestoreQueryLoader({
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
          final model = this.model(reference, data!)..onSnapshot(snapshot, data);
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
            model = this.model(reference, data!)..onSnapshot(snapshot, data);
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

FirestoreQueryLoader<M> useEntities<M extends FirestoreEntity>({
  required Query<FirestoreData> query,
  required FirestoreEntityFactory<M> model,
  CanUpdateFirestoreEntity<M>? canUpdate,
}) {
  return useSubscribable(
    model: FirestoreQueryLoader(
      reference: query,
      model: model,
      canUpdate: canUpdate,
    ),
    update: (FirestoreQueryLoader state, FirestoreQueryLoader created) {
      if (_areEqual(state.reference, created.reference)) {
        // print('same ${state.reference.parameters}');
        return;
      }
      // print('changed ${state.reference.parameters} -> ${created.reference.parameters}');
      state.updateReference(created.reference);
    },
  );
}

bool _areListsEqual(List<dynamic> a, List<dynamic> b) {
  if (a.length != b.length) {
    return false;
  }
  for (int i = 0; i < a.length; i++) {
    final av = a[i];
    final bv = b[i];
    if (!_areDynamicEqual(av, bv)) {
      return false;
    }
  }
  return true;
}

bool _areDynamicEqual(dynamic a, dynamic b) {
  if (a is List<dynamic> && b is List<dynamic>) {
    if (!_areListsEqual(a, b)) {
      return false;
    }
  } else if (a != b) {
    // print('fallback $a $b');
    return false;
  }
  // print('equal $a $b');
  return true;
}

bool _areMapsEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
  if (a.length != b.length) {
    // print('length');
    return false;
  }

  for (var ae in a.entries) {
    final key = ae.key;
    final av = ae.value;
    final bv = b[key];
    if (av.runtimeType != bv.runtimeType) {
      // print('runtimeType ${av.runtimeType} ${bv.runtimeType}');
      return false;
    }
    if (!_areDynamicEqual(av, bv)) {
      return false;
    }
  }
  return true;
}

bool _areEqual(Query<dynamic> a, Query<dynamic> b) {
  final ap = a.parameters;
  final bp = b.parameters;
  return _areMapsEqual(ap, bp);
}
