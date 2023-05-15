import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/project.dart';
import '../../base/footer_tabs.dart';
import 'sidebar/nodes.dart';
import 'sidebar/workspaces.dart';

class ProjectSidebar extends ConsumerWidget {
  const ProjectSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints.expand(width: 250),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ProjectSidebarContent(),
          ),
          ProjectSidebarTabs(placement: IconTabsPlacement.bottom),
        ],
      ),
    );
  }
}

String _watchSelectedSidebarTab(WidgetRef ref) {
  return ref.watch(projectStateModelProvider.select((value) => value.sidebarTab)) ?? 'nodes';
}

class ProjectSidebarContent extends ConsumerWidget {
  const ProjectSidebarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = _watchSelectedSidebarTab(ref);
    if (selected == 'nodes') {
      return const ProjectNodesListView();
    } else if (selected == 'workspaces') {
      return const ProjectWorkspacesListView();
    }
    return Container();
  }
}

class ProjectSidebarTabs extends ConsumerWidget {
  const ProjectSidebarTabs({
    super.key,
    required this.placement,
  });

  final IconTabsPlacement placement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = _watchSelectedSidebarTab(ref);

    return IconTabs<String>(
      placement: placement,
      items: [
        const IconTab(icon: Icon(FluentIcons.emoji_tab_symbols), value: 'nodes'),
        const IconTab(icon: Icon(FluentIcons.screen), value: 'workspaces'),
      ],
      selected: selected,
      onSelect: (value) {
        ref.read(projectStateModelProvider).updateSidebarTab(value);
      },
    );
  }
}
