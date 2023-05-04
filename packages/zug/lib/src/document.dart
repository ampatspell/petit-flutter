import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'base.dart';
import 'entity.dart';
import 'hook.dart';

part 'document.g.dart';

class FirestoreDocumentLoader<M extends FirestoreEntity> extends _FirestoreDocumentLoader<M>
    with _$FirestoreDocumentLoader {
  FirestoreDocumentLoader({
    required super.reference,
    required super.model,
    required super.canUpdate,
  });

  @override
  String toString() {
    return 'FirestoreDocumentLoader{isLoading: $isLoading, content: $content}';
  }
}

abstract class _FirestoreDocumentLoader<M extends FirestoreEntity>
    extends FirestoreModelsBase<M, DocumentSnapshot<FirestoreData>> with Store {
  final DocumentReference<FirestoreData> reference;

  _FirestoreDocumentLoader({
    required this.reference,
    required FirestoreEntityFactory<M> model,
    required CanUpdateFirestoreEntity<M>? canUpdate,
  }) : super(
          subscribe: () => reference.snapshots(includeMetadataChanges: true),
          model: model,
          canUpdate: canUpdate,
        );

  @observable
  M? content;

  @computed
  String get asString {
    return toString();
  }

  @override
  void onRefresh() {}

  @override
  void onSnapshot(DocumentSnapshot<FirestoreData> snapshot) {
    final reference = snapshot.reference;
    if (snapshot.exists) {
      final data = snapshot.data()!;
      if (content != null) {
        M next = content!;
        if (reference.path != reference.path) {
          next = model(reference)..onSnapshot(snapshot, data);
        } else {
          if (canUpdate != null && !canUpdate!(next, snapshot, data)) {
            next = model(reference);
          }
          next.onSnapshot(snapshot, data);
        }
        if (content != next) {
          content = next;
        }
      } else {
        content = model(reference)..onSnapshot(snapshot, data);
      }
    } else {
      if (content != null) {
        content!.onDeleted(snapshot);
      }
      content = null;
    }
    isFromCache = snapshot.metadata.isFromCache;
    hasPendingWrites = snapshot.metadata.hasPendingWrites;
    isLoading = false;
  }

  void updateReference(DocumentReference<FirestoreData> reference) {
    replaceStream(() => reference.snapshots(includeMetadataChanges: true));
  }
}

FirestoreDocumentLoader<M> useEntity<M extends FirestoreEntity>({
  required DocumentReference<FirestoreData> reference,
  required FirestoreEntityFactory<M> model,
  CanUpdateFirestoreEntity<M>? canUpdate,
}) {
  return useSubscribable(
    model: FirestoreDocumentLoader(
      reference: reference,
      model: model,
      canUpdate: canUpdate,
    ),
    update: (FirestoreDocumentLoader state, FirestoreDocumentLoader created) {
      if (state.reference.path == created.reference.path) {
        // print('same ${state.reference.path}');
        return;
      } else {
        // print('changed ${state.reference.path} -> ${created.reference.path}');
      }
      state.updateReference(created.reference);
    },
  );
}
