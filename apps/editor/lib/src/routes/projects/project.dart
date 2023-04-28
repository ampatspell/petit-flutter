import 'package:fluent_ui/fluent_ui.dart';

import '../screen/fluent.dart';

class ProjectScreen extends StatelessWidget {
  final String projectId;

  ProjectScreen({
    super.key,
    required this.projectId,
  }) {
    FluentScreenContext.instance.buildAppBarActions = null;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text('Project $projectId'),
      ),
      content: const Center(child: Text("Project")),
    );
  }
}
