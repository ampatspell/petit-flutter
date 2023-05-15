import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sidebar.dart';
import 'workspace.dart';

class ProjectScreenScaffoldContent extends ConsumerWidget {
  const ProjectScreenScaffoldContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSidebar(),
        Expanded(
          child: ProjectWorkspace(),
        ),
      ],
    );
  }
}
