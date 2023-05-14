import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sidebar/nodes.dart';

class ProjectSidebar extends ConsumerWidget {
  const ProjectSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints.expand(width: 250),
      child: const ProjectNodesListView(),
    );
  }
}
