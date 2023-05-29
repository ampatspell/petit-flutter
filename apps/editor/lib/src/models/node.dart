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

  void updateWidth(int value);

  void updateHeight(int value);
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

  @override
  Future<void> updateWidth(int value) async {
    await doc.merge({'width': value});
  }

  @override
  Future<void> updateHeight(int value) async {
    await doc.merge({'height': value});
  }

  Future<void> updateColorValue(int value) async {
    await doc.merge({'color': value});
  }

  Future<void> updateColor(Color value) async {
    await updateColorValue(value.value);
  }
}
