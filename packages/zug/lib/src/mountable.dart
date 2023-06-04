part of '../zug.dart';

ObservableList<Mountable> mounted = ObservableList();

mixin Mountable {
  bool _isMounted = false;

  bool get isMounted => _isMounted;

  @mustCallSuper
  void onMounted() {
    transaction(() => mounted.add(this));
    // debugPrint('mount: $this');
  }

  @mustCallSuper
  void onUnmounted() {
    transaction(() => mounted.remove(this));
    // debugPrint('unmount: $this');
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
