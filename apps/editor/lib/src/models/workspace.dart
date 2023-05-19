import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'workspace.freezed.dart';

@freezed
class WorkspaceModel with _$WorkspaceModel implements HasDoc {
  const factory WorkspaceModel({
    required Doc doc,
  }) = _WorkspaceModel;

  const WorkspaceModel._();

  String get name => doc['name'] as String;

  Future<void> delete() async {
    await doc.delete();
  }
}

@freezed
class WorkspaceStateModel with _$WorkspaceStateModel implements HasDoc {
  const factory WorkspaceStateModel({
    required Doc doc,
  }) = _WorkspaceStateModel;

  const WorkspaceStateModel._();
}

@freezed
class WorkspaceItemModel with _$WorkspaceItemModel implements HasDoc {
  const factory WorkspaceItemModel({
    required Doc doc,
  }) = _WorkspaceItemModel;

  const WorkspaceItemModel._();

  int get x => doc['x'] as int;

  int get y => doc['y'] as int;

  int get pixel => doc['pixel'] as int? ?? 1;

  String get node => doc['node'] as String;

  Offset get position => Offset(x.toDouble(), y.toDouble());

  Offset renderedPosition(int pixel) {
    return position * pixel.toDouble();
  }
}
