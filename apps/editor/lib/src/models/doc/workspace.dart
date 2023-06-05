part of '../models.dart';

class WorkspaceDoc = _WorkspaceDoc with _$WorkspaceDoc;

abstract class _WorkspaceDoc with Store, Mountable implements DocumentModel {
  _WorkspaceDoc(this.doc);

  @override
  final Document doc;

  String get id => doc.id;

  String get name => doc['name'] as String;

  int get pixel => doc['pixel'] as int? ?? 1;

  @override
  String toString() {
    return 'WorkspaceDoc{id: $id, data: ${doc.data}}';
  }
}
