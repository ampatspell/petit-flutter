part of '../zug.dart';

ObservableList<Mountable> mounted = ObservableList();

mixin Mountable {
  bool _isMounted = false;

  bool get isMounted => _isMounted;

  @mustCallSuper
  void onMounted() {
    runInAction(() => mounted.add(this));
    print('onMounted $this');
  }

  @mustCallSuper
  void onUnmounted() {
    print('onUnmounted $this');
    runInAction(() => mounted.remove(this));
  }

  Iterable<Mountable> get mountable;

  void mount() {
    runInAction(() {
      if (isMounted) {
        return;
      }
      for (final child in mountable) {
        child.mount();
      }
      _isMounted = true;
      onMounted();
    });
  }

  void unmount() {
    runInAction(() {
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
