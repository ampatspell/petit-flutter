import 'dart:ui';

import 'package:mobx/mobx.dart';

part 'node.g.dart';

abstract class Node {
  NodeFrame get frame;

  String get id;
}

class NodeFrame extends _NodeFrame with _$NodeFrame {
  @override
  String toString() {
    return 'EditorAreaFrameStore{offset: $offset, size: $size}';
  }
}

abstract class _NodeFrame with Store {
  @observable
  Offset offset = const Offset(100, 100);

  @observable
  Size size = const Size(300, 200);

  @action
  void updateOffset(Offset offset) {
    this.offset = offset;
  }

  @action
  void updateSize(Size size) {
    this.size = size;
  }

  @action
  void updateSizeAndOffset(Size size, Offset offset) {
    this.size = size;
    this.offset = offset;
  }
}
