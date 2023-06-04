import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../../../app/router.dart';
import '../../../mobx/mobx.dart';
import '../../loading.dart';
import 'editor/editor.dart';
import 'inspector/inspector.dart';

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
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: WorkspaceEditor()),
        WorkspaceInspector(),
      ],
    );
  }
}
