import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project_node.freezed.dart';

abstract class ProjectNodeDoc {
  Doc get doc;

  String get type;
}

@freezed
class ProjectBoxNodeDoc with _$ProjectBoxNodeDoc implements ProjectNodeDoc {
  const factory ProjectBoxNodeDoc({
    required Doc doc,
  }) = _ProjectBoxNodeDoc;

  const ProjectBoxNodeDoc._();

  @override
  String get type => doc['type'] as String;
}
