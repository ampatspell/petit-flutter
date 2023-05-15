import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project_workspaces.freezed.dart';

@freezed
class ProjectWorkspaceStateModel with _$ProjectWorkspaceStateModel {
  const factory ProjectWorkspaceStateModel({
    required Doc doc,
  }) = _ProjectWorkspaceStateModel;

  const ProjectWorkspaceStateModel._();
}
