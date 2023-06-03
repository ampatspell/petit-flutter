part of '../mobx.dart';

class ProjectDoc = _ProjectDoc with _$ProjectDoc;

@StoreConfig(hasToString: false)
abstract class _ProjectDoc with Store, Mountable implements DocumentModel {
  _ProjectDoc({
    required this.doc,
  });

  @override
  Iterable<Mountable> get mountable => [];

  @override
  final Document doc;

  String get id => doc.id;

  String get name => doc['name'] as String;
}
