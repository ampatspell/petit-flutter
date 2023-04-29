import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'entity.dart';
import 'stream.dart';

part 'base.g.dart';

typedef FirestoreData = Map<String, dynamic>;

typedef FirestoreEntityFactory<M extends FirestoreEntity> = M Function(
  DocumentReference<FirestoreData> reference,
);

typedef CanUpdateFirestoreEntity<M extends FirestoreEntity> = bool Function(
  M model,
  DocumentSnapshot<FirestoreData> snapshot,
  FirestoreData? data,
);

abstract class FirestoreModelsBase<M extends FirestoreEntity, S>
    extends _FirestoreModelsBase<M, S> {
  FirestoreModelsBase({
    required super.subscribe,
    required super.model,
    required super.canUpdate,
  });
}

abstract class _FirestoreModelsBase<M extends FirestoreEntity, S>
    with Store
    implements Subscribable {
  late final StreamSubscriptions<S> _subscriptions;
  final FirestoreEntityFactory<M> model;
  final CanUpdateFirestoreEntity<M>? canUpdate;

  _FirestoreModelsBase({
    required Stream<S> Function() subscribe,
    required this.model,
    required this.canUpdate,
  }) {
    _subscriptions = StreamSubscriptions(
      subscribe: () => subscribe(),
      onEvent: onSnapshot,
      onSubscribed: () => _onLoading(),
    );
  }

  @action
  void _onLoading() {
    isLoading = true;
  }

  void onSnapshot(S querySnapshot);

  @observable
  bool isLoading = false;

  @observable
  bool? isFromCache;

  @observable
  bool? hasPendingWrites;

  @override
  Subscription subscribe() {
    return _subscriptions.subscribe();
  }

  @override
  @computed
  get isSubscribed {
    return _subscriptions.isSubscribed;
  }
}
