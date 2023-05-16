import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/project_workspace.dart';
import '../base.dart';
import '../generic.dart';
import 'project.dart';

part 'workspaces.g.dart';

@Riverpod(dependencies: [projectReference, projectWorkspaceModelsStreamByProjectReference])
Stream<List<ProjectWorkspaceModel>> projectWorkspaceModelsStream(ProjectWorkspaceModelsStreamRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  return ref.watch(projectWorkspaceModelsStreamByProjectReferenceProvider(
    projectRef: projectRef,
  ));
}

//

@Riverpod(dependencies: [])
List<ProjectWorkspaceModel> projectWorkspaceModels(ProjectWorkspaceModelsRef ref) => throw OverrideProviderException();
