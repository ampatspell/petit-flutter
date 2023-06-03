part of '../mobx.dart';

class ProjectNodeDoc = _ProjectNodeDoc with _$ProjectNodeDoc;

@StoreConfig(hasToString: false)
abstract class _ProjectNodeDoc with Store, Mountable implements DocumentModel {
  _ProjectNodeDoc(this.doc);

  @override
  final Document doc;

  @override
  String toString() {
    return 'ProjectNodeDoc{id: ${doc.id}, data: ${doc.data}';
  }
}
