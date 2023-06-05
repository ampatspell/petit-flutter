import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../models/models.dart';
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

class WorkspaceScreenContent extends StatelessWidget {
  const WorkspaceScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Tools(),
              const Expanded(child: WorkspaceEditor()),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Grey.grey245,
              ),
            ),
          ),
          child: const WorkspaceInspector(),
        ),
      ],
    );
  }
}

class _Tools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withAlpha(20),
      constraints: const BoxConstraints.expand(height: 40),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const Text('Tools'),
    );
  }
}
