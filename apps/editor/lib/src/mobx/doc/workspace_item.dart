part of '../mobx.dart';

class WorkspaceItemDoc = _WorkspaceItemDoc with _$WorkspaceItemDoc;

abstract class _WorkspaceItemDoc with Store, Mountable implements DocumentModel {
  _WorkspaceItemDoc(this.doc);

  @override
  final Document doc;

  String get id => doc.id;

  @override
  String toString() {
    return 'WorkspaceItemDoc{id: ${doc.id} data: ${doc.data}';
  }
}
