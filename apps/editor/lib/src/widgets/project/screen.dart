import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../../app/router.dart';
import '../../models/models.dart';
import '../loading.dart';
import 'screen/scaffold.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({
    super.key,
    required this.projectId,
  });

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return MountingProvider(
      create: (context) => Project(id: projectId),
      child: MountingProvider(
        create: (context) => Workspaces(project: context.read()),
        child: Load<Workspaces>(
          onMissing: (context) => ProjectsRoute().go(context),
          child: const ProjectScreenScaffold(),
        ),
      ),
    );
  }
}
