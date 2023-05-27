import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../providers/project/workspace/editor.dart';
import '../../../../providers/project/workspace/workspace.dart';
import '../../../base/fields/fields.dart';

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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FieldPixels(
              provider: workspacePixelFieldProvider,
              label: false,
            ),
          ),
        ],
      ),
    );
  }
}

class InspectorContainer extends StatelessWidget {
  const InspectorContainer({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class InspectorRow extends StatelessWidget {
  const InspectorRow({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: child,
        ),
        const SizedBox(
          height: 1,
          width: double.infinity,
          child: ColoredBox(
            color: Grey.grey245,
          ),
        ),
      ],
    );
  }
}

class WorkspaceInspectorContent extends ConsumerWidget {
  const WorkspaceInspectorContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasItem = ref.watch(selectedWorkspaceItemModelProvider.select((value) => value != null));

    // final node = ref.watch(selectedNodeModelProvider);
    return InspectorContainer(children: [
      if (hasItem) ...[
        const WorkspaceInspectorItemPosition(),
        const WorkspaceInspectorItemPixel(),
      ],
    ]);
  }
}

class WorkspaceInspectorItemPixel extends ConsumerWidget {
  const WorkspaceInspectorItemPixel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InspectorRow(
      child: FieldPixels(
        provider: selectedWorkspaceItemPixelFieldProvider,
      ),
    );
  }
}

class WorkspaceInspectorItemPosition extends ConsumerWidget {
  const WorkspaceInspectorItemPosition({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InspectorRow(
      child: Row(
        children: [
          Expanded(
            child: FieldTextBox(provider: selectedWorkspaceItemXFieldProvider),
          ),
          const Gap(10),
          Expanded(
            child: FieldTextBox(provider: selectedWorkspaceItemYFieldProvider),
          ),
        ],
      ),
    );
  }
}
