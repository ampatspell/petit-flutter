part of '../zug.dart';

ObservableList<Mountable> mounted = ObservableList();

mixin Mountable {
  bool _isMounted = false;

  bool get isMounted => _isMounted;

  @mustCallSuper
  void onMounted() {
    transaction(() => mounted.add(this));
  }

  @mustCallSuper
  void onUnmounted() {
    transaction(() => mounted.remove(this));
  }

  Iterable<Mountable> get mountable;

  void _mount() {
    transaction(() {
      if (isMounted) {
        return;
      }
      for (final child in mountable) {
        child._mount();
      }
      _isMounted = true;
      onMounted();
    });
  }

  void _unmount() {
    transaction(() {
      if (!isMounted) {
        return;
      }
      _isMounted = false;
      onUnmounted();
      for (final child in mountable) {
        child._unmount();
      }
    });
  }
}