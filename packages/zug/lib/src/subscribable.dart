part of '../zug.dart';

class StreamWithSource<S, R> {
  const StreamWithSource({required this.stream, required this.source});

  static StreamWithSource<MapDocumentSnapshot, MapDocumentReference>? fromDocumentReferenceProvider(
      MapDocumentReferenceProvider? provider) {
    if (provider == null) {
      return null;
    }
    final reference = provider();
    if (reference == null) {
      return null;
    }
    return StreamWithSource(
      stream: reference.snapshots(includeMetadataChanges: false),
      source: reference,
    );
  }

  static StreamWithSource<MapQuerySnapshot, MapQuery>? fromQueryProvider(MapQueryProvider? provider) {
    if (provider == null) {
      return null;
    }
    final reference = provider();
    if (reference == null) {
      return null;
    }
    return StreamWithSource(
      stream: reference.snapshots(includeMetadataChanges: false),
      source: reference,
    );
  }

  final Stream<S> stream;
  final R source;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StreamWithSource && runtimeType == other.runtimeType && source == other.source;
  }

  @override
  int get hashCode => source.hashCode;
}

typedef SnapshotSubscribableStreamProvider<S, R> = StreamWithSource<S, R>? Function();

mixin SnapshotSubscribable<T, S, R> {
  bool get isMounted;

  void _mountContent();

  void _unmountContent();

  void _clearContent();

  void _onSnapshot(S snapshot);

  //

  final Observable<SnapshotMetadata?> _metadata = Observable(null);

  SnapshotMetadata? get metadata => _metadata.value;

  bool? get isFromCache => metadata?.isFromCache;

  bool? get hasPendingWrites => metadata?.hasPendingWrites;

  //

  final Observable<bool> _isLoading = Observable(false);

  bool get isLoading => _isLoading.value;

  final Observable<bool> _isLoaded = Observable(false);

  bool get isLoaded => _isLoaded.value;

  //

  bool _needsClear = false;

  SnapshotSubscribableStreamProvider<S, R>? __streamProvider;

  final Observable<R?> __streamSource = Observable(null);

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

  StreamWithSource<S, R>? get _streamWithSource {
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
    runInAction(() {
      final streamWithSource = _streamWithSource;
      print('subscribe $streamWithSource');
      if (streamWithSource == null) {
        return;
      }

      final stream = streamWithSource.stream;
      final source = streamWithSource.source;

      _isLoading.value = true;
      final subscription = stream.listen((snapshot) => runInAction(() => __onSnapshot(snapshot)));
      __streamSource.value = source;
      _cancelStream = subscription.cancel;
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
      _isLoaded.value = true;
    }
  }

// void _unsubscribe() {
//   runInAction(() {
//     final cancel = _cancelStream;
//     if (cancel != null) {
//       _cancelStream = null;
//       cancel();
//     }
//     final cancelReaction = _cancelReaction;
//     if (cancelReaction != null) {
//       cancelReaction();
//       _cancelReaction = null;
//     }
//     _isLoading.value = false;
//     _unmountContent();
//   });
// }
}
