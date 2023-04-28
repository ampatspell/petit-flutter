import 'package:fluent_ui/fluent_ui.dart';

class ProjectScreen extends StatelessWidget {
  final String projectId;

  const ProjectScreen({
    super.key,
    required this.projectId,
  });

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
