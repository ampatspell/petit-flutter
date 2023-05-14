import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/project.dart';

class ProjectWorkspace extends ConsumerWidget {
  const ProjectWorkspace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(projectWorkspaceDocProvider);
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.red.withAlpha(10),
      child: Text(workspace.toString()),
    );
  }
}
