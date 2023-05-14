import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project_workspace.freezed.dart';

@freezed
class ProjectWorkspaceDoc with _$ProjectWorkspaceDoc {
  const ProjectWorkspaceDoc._();

  const factory ProjectWorkspaceDoc({
    required Doc doc,
  }) = _ProjectWorkspaceDoc;

  String get name => doc['name'] as String;

  Future<void> delete() async {
    await doc.delete();
  }
}
