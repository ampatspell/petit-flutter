part of '../mobx.dart';

class ProjectNodeDoc = _ProjectNodeDoc with _$ProjectNodeDoc;

@StoreConfig(hasToString: false)
abstract class _ProjectNodeDoc with Store, Mountable implements DocumentModel {
  _ProjectNodeDoc({
    required this.doc,
  });

  @override
  Iterable<Mountable> get mountable => [];

  @override
  final Document doc;

  @override
  String toString() {
    return '_ProjectNodeDoc{}';
  }
}
