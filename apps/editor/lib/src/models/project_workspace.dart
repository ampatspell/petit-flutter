import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project_workspace.freezed.dart';

@freezed
class ProjectWorkspaceModel with _$ProjectWorkspaceModel {
  const factory ProjectWorkspaceModel({
    required Doc doc,
  }) = _ProjectWorkspaceModel;

  const ProjectWorkspaceModel._();

  String get name => doc['name'] as String;

  Future<void> delete() async {
    await doc.delete();
  }
}
