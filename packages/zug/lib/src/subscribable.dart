part of '../zug.dart';

ObservableList<SubscribableSubscription> subscriptions = ObservableList();

class SubscribableSubscription {
  const SubscribableSubscription(this.source);

  final dynamic source;

  @override
  String toString() {
    return source.toString();
  }
}

void Function() _registerSubscription(dynamic source) {
  final subscription = SubscribableSubscription(source);
  transaction(() => subscriptions.add(subscription));
  return () => transaction(() => subscriptions.remove(subscription));
}

class StreamAndSource<S, R> {
  const StreamAndSource({required this.stream, required this.source});

  static StreamAndSource<MapDocumentSnapshot, MapDocumentReference>? fromDocumentReferenceProvider(
      MapDocumentReferenceProvider? provider) {
    if (provider == null) {
      return null;
    }
    final reference = provider();
    if (reference == null) {
      return null;
    }
    return StreamAndSource(
      stream: reference.snapshots(includeMetadataChanges: false),
      source: reference,
    );
  }

  static StreamAndSource<MapQuerySnapshot, MapQuery>? fromQueryProvider(MapQueryProvider? provider) {
    if (provider == null) {
      return null;
    }
    final reference = provider();
    if (reference == null) {
      return null;
    }
    return StreamAndSource(
      stream: reference.snapshots(includeMetadataChanges: false),
      source: reference,
    );
  }

  final Stream<S> stream;
  final R source;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StreamAndSource && runtimeType == other.runtimeType && source == other.source;
  }

  @override
  int get hashCode => source.hashCode;
}

typedef SnapshotSubscribableStreamProvider<S, R> = StreamAndSource<S, R>? Function();

mixin SnapshotSubscribable<T, S, R> {
  bool get isMounted;

  bool get isMissing;

  void _mountContent();

  void _unmountContent();

  void _clearContent();

  void _onSnapshot(S snapshot);

  //

  bool _needsClear = false;

  //

  final Observable<SnapshotMetadata?> _metadata = Observable(null, name: 'Subscribable.metadata');

  SnapshotMetadata? get metadata => _metadata.value;

  bool? get isFromCache => metadata?.isFromCache;

  bool? get hasPendingWrites => metadata?.hasPendingWrites;

  //

  final Observable<bool> _isLoading = Observable(false, name: 'Subscribable.isLoading');

  bool get isLoading => _isLoading.value;

  final Observable<bool> _isLoaded = Observable(false, name: 'Subscribable.isLoaded');

  bool get isLoaded => _isLoaded.value;

  //

  SnapshotSubscribableStreamProvider<S, R>? __streamProvider;

  final Observable<R?> __streamSource = Observable(null, name: 'Subscribable.streamSource');

  R? get _streamSource => __streamSource.value;

  void Function()? _cancelStream;

  ReactionDisposer? _cancelReaction;

  set _streamProvider(SnapshotSubscribableStreamProvider<S, R> provider) {
    __streamProvider = provider;
  }

  void _onMounted() {
    _needsClear = true;
    _subscribeToStreamSource();
    _subscribeToStream();
  }

  void _onUnmounted() {
    _unsubscribeFromStreamSource();
    _unsubscribeFromStream();
    _unmountContent();
  }

  //

  StreamAndSource<S, R>? get _streamWithSource {
    final provider = __streamProvider;
    if (provider != null) {
      final model = provider();
      if (model != null) {
        return model;
      }
    }
    return null;
  }

  void _subscribeToStreamSource() {
    assert(isMounted);
    assert(_cancelReaction == null);

    _cancelReaction = reaction(
      (reaction) => _streamWithSource,
      (streamWithSource) {
        _unsubscribeFromStream();
        _subscribeToStream();
      },
      onError: (err, reaction) => debugPrint(err.toString()),
      name: 'Subscribable.streamProvider.reaction',
    );
  }

  void _unsubscribeFromStreamSource() {
    assert(_cancelStream != null);
    _cancelReaction!();
    _cancelReaction = null;
  }

  //

  void _subscribeToStream() {
    assert(isMounted);
    assert(_cancelStream == null);

    final streamWithSource = _streamWithSource;
    if (streamWithSource == null) {
      return;
    }

    final stream = streamWithSource.stream;
    final source = streamWithSource.source;

    transaction(() {
      if (_isLoading.value == false) {
        _isLoading.value = true;
      }
      final subscription = stream.listen((snapshot) => transaction(() => __onSnapshot(snapshot)));
      final cancelRegistration = _registerSubscription(source);
      __streamSource.value = source;
      _cancelStream = () {
        subscription.cancel();
        cancelRegistration();
      };
    });
  }

  void _unsubscribeFromStream() {
    assert(_cancelStream != null);
    _needsClear = true;
    _cancelStream!();
    _cancelStream = null;
  }

  void __onSnapshot(S snapshot) {
    if (_needsClear) {
      _needsClear = false;
      _unmountContent();
      _clearContent();
    }
    _onSnapshot(snapshot);
    _mountContent();
    if (_isLoading.value == true) {
      _isLoading.value = false;
    }
    if (_isLoaded.value == false) {
      _isLoaded.value = true;
    }
  }
}
