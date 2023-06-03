import 'package:freezed_annotation/freezed_annotation.dart';

import 'doc.dart';

part 'project.freezed.dart';

@Deprecated('use mobx')
@freezed
class ProjectModel with _$ProjectModel implements HasDoc {
  const factory ProjectModel({
    required Doc doc,
  }) = _ProjectModel;

  const ProjectModel._();

  String get name => doc['name'] as String;

  Future<void> delete() async {
    await doc.delete();
  }
}

@Deprecated('use mobx')
@freezed
class ProjectStateModel with _$ProjectStateModel implements HasDoc {
  const factory ProjectStateModel({
    required Doc doc,
  }) = _ProjectStateModel;

  const ProjectStateModel._();
}
