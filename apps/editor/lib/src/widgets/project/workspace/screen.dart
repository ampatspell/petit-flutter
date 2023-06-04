import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../../../app/router.dart';
import '../../../mobx/mobx.dart';
import '../../loading.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({
    super.key,
    required this.projectId,
    required this.workspaceId,
  });

  final String projectId;
  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    return MountingProvider(
      create: (context) => Project(id: projectId),
      child: MountingProvider(
        create: (context) => Workspace(project: context.read<Project>(), id: workspaceId),
        child: Load<Workspace>(
          onMissing: (context) => ProjectRoute(projectId: projectId).go(context),
          child: const WorkspaceScreenContent(),
        ),
      ),
    );
  }
}

class WorkspaceScreenContent extends ConsumerWidget {
  const WorkspaceScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Observer(builder: (context) {
      final workspace = context.watch<Workspace>();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(workspace.toString()),
          Text(workspace.items.toString()),
          Text(workspace.project.toString()),
          Text(workspace.project.nodes.toString()),
        ],
      );
    });

    // return const Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Expanded(child: WorkspaceEditor()),
    //     WorkspaceInspector(),
    //   ],
    // );
  }
}
