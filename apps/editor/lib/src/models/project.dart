import 'package:freezed_annotation/freezed_annotation.dart';

import 'references.dart';

part 'project.freezed.dart';

@freezed
class ProjectDoc with _$ProjectDoc {
  const ProjectDoc._();

  const factory ProjectDoc({
    required Doc doc,
  }) = _ProjectDoc;

  String get name => doc['name'] as String;

  String? get workspace => doc['workspace'] as String?;

  String? get node => doc['node'] as String?;

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
