import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'node.dart';
import 'node/container.dart';

part 'area.g.dart';

class EditorArea extends _EditorArea with _$EditorArea {
  @override
  String toString() {
    return 'EditorAreaStore{nodes: $nodes}';
  }
}

abstract class _EditorArea with Store {
  @observable
  ObservableList<Node> nodes = ObservableList.of([
    ContainerNode.build(const Offset(100, 100), const Size(200, 100), Colors.redAccent, 'red'),
    ContainerNode.build(const Offset(200, 250), const Size(200, 100), Colors.greenAccent, 'green'),
  ]);

  @action
  void didMoveNode(Node node) {
    nodes.remove(node);
    nodes.add(node);
  }
}
