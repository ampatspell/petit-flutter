import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project.freezed.dart';

@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    required Doc doc,
  }) = _ProjectModel;

  const ProjectModel._();

  String get name => doc['name'] as String;

  String? get workspace => doc['workspace'] as String?;

  String? get node => doc['node'] as String?;

  String? get sidebarTab => doc['sidebar_tab'] as String?;

  int get pixel => doc['pixel'] as int? ?? 2;

  Future<void> updateSidebarTab(String? value) async {
    await doc.merge({
      'sidebar_tab': value,
    });
  }

  Future<void> updateWorkspaceId(String? id) async {
    await doc.merge({
      'workspace': id,
    });
  }

  Future<void> updateNodeId(String? id) async {
    await doc.merge({
      'node': id,
    });
  }

  Future<void> delete() async {
    await doc.delete();
  }
}
