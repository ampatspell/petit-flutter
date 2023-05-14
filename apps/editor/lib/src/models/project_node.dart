import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project_node.freezed.dart';

abstract class ProjectNodeModel {
  Doc get doc;

  String get type;
}

@freezed
class ProjectBoxNodeModel with _$ProjectBoxNodeModel implements ProjectNodeModel {
  const factory ProjectBoxNodeModel({
    required Doc doc,
  }) = _ProjectBoxNodeModel;

  const ProjectBoxNodeModel._();

  @override
  String get type => doc['type'] as String;
}
