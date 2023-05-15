import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/theme.dart';
import '../../../providers/project.dart';

class ProjectWorkspace extends ConsumerWidget {
  const ProjectWorkspace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(projectWorkspaceModelProvider);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Grey.grey245),
          top: BorderSide(color: Grey.grey245),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(workspace.toString()),
      ),
    );
  }
}
