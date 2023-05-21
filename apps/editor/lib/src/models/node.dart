import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'doc.dart';

part 'node.freezed.dart';

abstract class NodeModel implements HasDoc {
  const NodeModel();

  String get type => doc['type'] as String;
}

mixin NodeModelWithSize {
  int get width;

  int get height;

  Size get size {
    return Size(width.toDouble(), height.toDouble());
  }

  Size renderedSize(int itemPixel, int workspacePixel) {
    return size * itemPixel.toDouble() * workspacePixel.toDouble();
  }
}

@freezed
class BoxNodeModel extends NodeModel with _$BoxNodeModel, NodeModelWithSize {
  const factory BoxNodeModel({
    required Doc doc,
  }) = _BoxNodeModel;

  const BoxNodeModel._();

  @override
  int get width => doc['width'] as int;

  @override
  int get height => doc['height'] as int;

  Color get color => Color(doc['color'] as int);
}
