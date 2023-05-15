import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project_node.freezed.dart';

abstract class ProjectNodeModel {
  const ProjectNodeModel();

  Doc get doc;

  String get type => doc['type'] as String;
}

mixin ProjectNodeModelWithSize {
  int get width;
  int get height;

  Size get size {
    return Size(width.toDouble(), height.toDouble());
  }

  Size renderedSize(int itemPixel, int projectPixel) {
    return size * itemPixel.toDouble() * projectPixel.toDouble();
  }
}

@freezed
class ProjectBoxNodeModel extends ProjectNodeModel with _$ProjectBoxNodeModel, ProjectNodeModelWithSize {
  const factory ProjectBoxNodeModel({
    required Doc doc,
  }) = _ProjectBoxNodeModel;

  const ProjectBoxNodeModel._();

  @override
  int get width => doc['width'] as int;

  @override
  int get height => doc['height'] as int;

  Color get color => Color(doc['color'] as int);
}
