part of '../mobx.dart';

class WorkspaceItemDoc = _WorkspaceItemDoc with _$WorkspaceItemDoc;

abstract class _WorkspaceItemDoc with Store, Mountable implements DocumentModel {
  _WorkspaceItemDoc(this.doc);

  @override
  final Document doc;

  String get id => doc.id;

  int get x => doc['x'] as int;

  int get y => doc['y'] as int;

  int get pixel => doc['pixel'] as int? ?? 1;

  String get node => doc['node'] as String;

  set x(int x) => doc['x'] = x;

  set y(int y) => doc['y'] = y;

  @override
  String toString() {
    return 'WorkspaceItemDoc{id: ${doc.id} data: ${doc.data}';
  }
}
