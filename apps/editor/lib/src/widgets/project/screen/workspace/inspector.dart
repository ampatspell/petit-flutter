import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/project.dart';

class ProjectWorkspaceInspector extends ConsumerWidget {
  const ProjectWorkspaceInspector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final node = ref.watch(selectedProjectNodeModelProvider);
    return Container(
      constraints: const BoxConstraints.expand(width: 250),
      padding: const EdgeInsets.all(10),
      child: Text(node.toString()),
    );
  }
}
