import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project_node.freezed.dart';

abstract class ProjectNodeModel {
  const ProjectNodeModel();

  Doc get doc;

  String get type => doc['type'] as String;
}

@freezed
class ProjectBoxNodeModel extends ProjectNodeModel with _$ProjectBoxNodeModel {
  const factory ProjectBoxNodeModel({
    required Doc doc,
  }) = _ProjectBoxNodeModel;

  const ProjectBoxNodeModel._();

  int get width => doc['width'] as int;

  int get height => doc['height'] as int;

  Color get color => Color(doc['color'] as int);
}
