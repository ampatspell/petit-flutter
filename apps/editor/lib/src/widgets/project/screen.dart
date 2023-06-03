import 'package:fluent_ui/fluent_ui.dart';
import 'package:zug/zug.dart';

import '../../app/router.dart';
import '../../mobx/mobx.dart';
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
      child: Load<Project>(
        onMissing: (context) => ProjectsRoute().go(context),
        child: const ProjectScreenScaffold(),
      ),
    );
  }
}
