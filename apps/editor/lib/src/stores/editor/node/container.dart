import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../node.dart';

part 'container.g.dart';

class ContainerNode extends _ContainerNode with _$ContainerNode, Node {
  ContainerNode();

  factory ContainerNode.build(Offset offset, Size size, Color color, String id) {
    return ContainerNode()
      ..frame.offset = offset
      ..frame.size = size
      ..color = color
      ..id = id;
  }
}

abstract class _ContainerNode with Store {
  NodeFrame frame = NodeFrame();

  @observable
  String id = '';

  @observable
  Color color = Colors.redAccent;

  @action
  void updateColor(Color color) {
    this.color = color;
  }

  Size clampSize(Size size) {
    var width = size.width;
    var height = size.height;
    const step = 10.0;
    width = (width / step).floorToDouble() * step;
    height = (height / step).floorToDouble() * step;
    return Size(width, height);
  }

  Offset clampOffset(Offset offset) {
    return offset;
  }
}
