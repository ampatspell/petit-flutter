import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project.freezed.dart';

@freezed
class ProjectModel with _$ProjectModel implements HasDoc {
  const factory ProjectModel({
    required Doc doc,
  }) = _ProjectModel;

  const ProjectModel._();

  String get name => doc['name'] as String; // ? ?? 'Untitled';

  String? get node => doc['node'] as String?;

  int get pixel => doc['pixel'] as int? ?? 2;

  // TODO: per workspace
  Future<void> updateNodeId(String? id) async {
    await doc.merge({
      'node': id,
    });
  }

  Future<void> delete() async {
    await doc.delete();
  }
}

@freezed
class ProjectStateModel with _$ProjectStateModel implements HasDoc {
  const factory ProjectStateModel({
    required Doc doc,
  }) = _ProjectStateModel;

  const ProjectStateModel._();

  String? get workspace => doc['workspace_id'] as String?;

  String? get sidebarTab => doc['sidebar_tab'] as String?;

  Future<void> updateSidebarTab(String? value) async {
    await doc.merge({
      'sidebar_tab': value,
    });
  }

  Future<void> updateWorkspaceId(String? id) async {
    await doc.merge({
      'workspace_id': id,
    });
  }
}
