import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/project_node.dart';
import '../base.dart';
import '../generic.dart';
import 'project.dart';

part 'nodes.g.dart';

@Riverpod(dependencies: [projectReference, projectNodeModelsByProjectReference])
Stream<List<ProjectNodeModel>> projectNodeModelsStream(ProjectNodeModelsStreamRef ref) {
  final projectRef = ref.watch(projectReferenceProvider);
  return ref.watch(projectNodeModelsByProjectReferenceProvider(
    projectRef: projectRef,
  ));
}

//

@Riverpod()
List<ProjectNodeModel> projectNodeModels(ProjectNodeModelsRef ref) => throw OverrideProviderException();
