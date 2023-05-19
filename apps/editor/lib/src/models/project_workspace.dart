import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project_workspace.freezed.dart';

@freezed
class ProjectWorkspaceModel with _$ProjectWorkspaceModel implements HasDoc {
  const factory ProjectWorkspaceModel({
    required Doc doc,
  }) = _ProjectWorkspaceModel;

  const ProjectWorkspaceModel._();

  String get name => doc['name'] as String;

  Future<void> delete() async {
    await doc.delete();
  }
}

@freezed
class ProjectWorkspaceStateModel with _$ProjectWorkspaceStateModel implements HasDoc {
  const factory ProjectWorkspaceStateModel({
    required Doc doc,
  }) = _ProjectWorkspaceStateModel;

  const ProjectWorkspaceStateModel._();
}

@freezed
class ProjectWorkspaceItemModel with _$ProjectWorkspaceItemModel implements HasDoc {
  const factory ProjectWorkspaceItemModel({
    required Doc doc,
  }) = _ProjectWorkspaceItemModel;

  const ProjectWorkspaceItemModel._();

  int get x => doc['x'] as int;

  int get y => doc['y'] as int;

  int get pixel => doc['pixel'] as int? ?? 1;

  String get node => doc['node'] as String;

  Offset get position => Offset(x.toDouble(), y.toDouble());

  Offset renderedPosition(int pixel) {
    return position * pixel.toDouble();
  }
}
