part of '../zug.dart';

typedef SnapshotSubscribableStreamProvider<S> = Stream<S> Function();

mixin SnapshotSubscribable<T, S> {
  bool get isMounted;

  void _mountContent();

  void _unmountContent();

  void _clearContent();

  void _onSnapshot(S snapshot);

  final Observable<SnapshotMetadata?> _metadata = Observable(null);

  SnapshotMetadata? get metadata => _metadata.value;

  final Observable<bool> _isLoading = Observable(false);

  bool get isLoading => _isLoading.value;

  final Observable<bool> _isLoaded = Observable(false);

  bool get isLoaded => _isLoaded.value;

  SnapshotSubscribableStreamProvider<S>? __streamProvider;
  void Function()? _cancel;

  set _streamProvider(SnapshotSubscribableStreamProvider<S>? provider) {
    _unsubscribe();
    __streamProvider = provider;
    _subscribe();
  }

  void _onMounted() {
    _subscribe();
    _mountContent();
  }

  void _onUnmounted() {
    _unmountContent();
    _unsubscribe();
  }

  void _subscribe() {
    runInAction(() {
      if (!isMounted) {
        return;
      }
      if (_cancel != null) {
        return;
      }
      final provider = __streamProvider;
      if (provider == null) {
        _metadata.value = null;
        _unmountContent();
        _clearContent();
        return;
      }
      _isLoading.value = true;
      final stream = provider();
      final subscription = stream.listen((snapshot) => runInAction(() => __onSnapshot(snapshot)));
      _cancel = subscription.cancel;
    });
  }

  void __onSnapshot(S snapshot) {
    _onSnapshot(snapshot);
    _mountContent();
    if (_isLoading.value == true) {
      _isLoading.value = false;
      _isLoaded.value = true;
    }
  }

  void _unsubscribe() {
    runInAction(() {
      final cancel = _cancel;
      if (cancel == null) {
        return;
      }
      _cancel = null;
      cancel();
      _isLoading.value = false;
      _unmountContent();
    });
  }
}
