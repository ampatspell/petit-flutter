import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/project/workspace/editor.dart';
import '../../../../providers/project/workspace/workspace.dart';
import '../../../base/line.dart';
import '../../../base/properties.dart';

class WorkspaceInspector extends ConsumerWidget {
  const WorkspaceInspector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: WorkspaceInspectorContent(),
            ),
          ),
          const HorizontalLine(),
          PropertiesWidget(
            provider: workspaceStateModelPropertiesProvider,
          ),
        ],
      ),
    );
  }
}

class WorkspaceInspectorContent extends ConsumerWidget {
  const WorkspaceInspectorContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasItem = ref.watch(selectedWorkspaceItemModelProvider.select((value) => value != null));
    final hasNode = ref.watch(selectedNodeModelProvider.select((value) => value != null));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasItem)
          PropertiesWidget(
            provider: selectedWorkspaceItemModelPropertiesProvider,
          ),
        if (hasNode)
          PropertiesWidget(
            provider: selectedNodeModelPropertiesProvider,
          ),
      ],
    );
  }
}
