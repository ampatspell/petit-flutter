part of '../zug.dart';

abstract class DocumentModel with Mountable {
  Document get doc;
}

typedef CreateModel<T> = T Function(Document doc);
