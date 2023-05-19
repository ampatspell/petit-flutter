// part 'nodes.g.dart';

// @Riverpod(dependencies: [projectReference, projectNodesRepositoryByProjectRef])
// Stream<List<ProjectNodeModel>> projectNodeModelsStream(ProjectNodeModelsStreamRef ref) {
//   final projectRef = ref.watch(projectReferenceProvider);
//   final repository = ref.watch(projectNodesRepositoryByProjectRefProvider(projectRef: projectRef));
//   return repository.all();
// }
//
// //
//
// @Riverpod()
// List<ProjectNodeModel> projectNodeModels(ProjectNodeModelsRef ref) => throw OverrideProviderException();
