part of '../zug.dart';

ObservableList<Mountable> mounted = ObservableList();

mixin Mountable {
  bool _isMounted = false;

  bool get isMounted => _isMounted;

  @mustCallSuper
  void onMounted() {
    transaction(() => mounted.add(this));
    // debugPrint('onMounted: $runtimeType');
  }

  @mustCallSuper
  void onUnmounted() {
    transaction(() => mounted.remove(this));
    // debugPrint('onUnmounted: $runtimeType');
  }

  Iterable<Mountable> get mountable => [];

  void mount() {
    transaction(() {
      if (isMounted) {
        return;
      }
      _isMounted = true;
      for (final child in mountable) {
        child.mount();
      }
      onMounted();
    });
  }

  void unmount() {
    transaction(() {
      if (!isMounted) {
        return;
      }
      _isMounted = false;
      onUnmounted();
      for (final child in mountable) {
        child.unmount();
      }
    });
  }
}
