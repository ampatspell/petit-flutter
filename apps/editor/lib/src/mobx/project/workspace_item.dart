part of '../mobx.dart';

class WorkspaceItem = _WorkspaceItem with _$WorkspaceItem;

@StoreConfig(hasToString: false)
abstract class _WorkspaceItem with Store, Mountable implements DocumentModel {
  _WorkspaceItem(this.itemDoc);

  final WorkspaceItemDoc itemDoc;

  @override
  Document get doc => itemDoc.doc;

  @override
  String toString() {
    return 'WorkspaceItem{doc: $itemDoc}';
  }
}
