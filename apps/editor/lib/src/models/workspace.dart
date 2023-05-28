import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'controllers.dart';
import 'doc.dart';

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

  String? get item => doc['item'] as String?;

  int get pixel => doc['pixel'] as int? ?? 2;

  Future<void> updateItem(String? value) async {
    await doc.merge({'item': value});
  }

  Future<void> updatePixel(int? value) async {
    await doc.merge({'pixel': value});
  }
}

@freezed
class WorkspaceItemModel with _$WorkspaceItemModel implements HasDoc {
  const factory WorkspaceItemModel({
    required Doc doc,
    required SnapshotStreamController<WorkspaceItemModel> controller,
  }) = _WorkspaceItemModel;

  const WorkspaceItemModel._();

  int get x => doc['x'] as int;

  int get y => doc['y'] as int;

  int get pixel => doc['pixel'] as int? ?? 1;

  String get node => doc['node'] as String;

  Offset get position => Offset(x.toDouble(), y.toDouble());

  Offset renderedPosition(int workspacePixel) {
    return position * workspacePixel.toDouble();
  }

  Future<void> updatePixel(int? value) async {
    await doc.merge({'pixel': value});
  }

  Future<void> updateX(int value) async {
    await doc.merge({'x': value});
  }

  Future<void> updateY(int value) async {
    await doc.merge({'y': value});
  }

  Future<void> updatePosition(Offset offset, bool save) async {
    final map = {
      'x': offset.dx.toInt(),
      'y': offset.dy.toInt(),
    };
    // TODO: controller.scheduleSave
    controller.merge(this, map);
    if (save) {
      await doc.merge(map, force: true);
    }
  }
}

@freezed
class PixelOptions with _$PixelOptions {
  const factory PixelOptions({
    @Default([1, 2, 4, 8, 16]) List<int> values,
  }) = _PixelOptions;
}
