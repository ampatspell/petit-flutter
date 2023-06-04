part of '../mobx.dart';

class WorkspaceItem = _WorkspaceItem with _$WorkspaceItem;

abstract class _WorkspaceItem with Store, Mountable implements DocumentModel {
  _WorkspaceItem(this.itemDoc);

  final WorkspaceItemDoc itemDoc;

  @override
  Document get doc => itemDoc.doc;

  String get id => doc.id;

  int get x => doc['x'] as int;

  int get y => doc['y'] as int;

  int get pixel => doc['pixel'] as int? ?? 1;

  String get node => doc['node'] as String;

  Offset get position => Offset(x.toDouble(), y.toDouble());

  Offset renderedPosition(int workspacePixel) {
    return position * workspacePixel.toDouble();
  }

  @override
  String toString() {
    return 'WorkspaceItem{id: $id, x: $x, y: $y, pixel: $pixel, node: $node}';
  }
}
