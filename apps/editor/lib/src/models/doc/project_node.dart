part of '../models.dart';

abstract class ProjectNodeDoc implements DocumentModel {}

class BoxProjectNodeDoc = _BoxProjectNodeDoc with _$BoxProjectNodeDoc, _$_BoxProjectNodeDoc<BoxProjectNodeDoc>;

abstract class _BoxProjectNodeDoc extends _ProjectNodeDoc<BoxProjectNodeDoc> with Store {
  _BoxProjectNodeDoc(super.doc);

  @override
  String toString() {
    return '$runtimeType{id: ${doc.id}, data: ${doc.data}';
  }
}

abstract class _ProjectNodeDoc<T> with Store, Mountable implements ProjectNodeDoc {
  _ProjectNodeDoc(this.doc);

  @override
  final Document doc;
}
