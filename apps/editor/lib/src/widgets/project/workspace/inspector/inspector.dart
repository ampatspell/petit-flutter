import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/properties.dart';
import '../../../../providers/project/workspace/editor.dart';
import '../../../../providers/project/workspace/workspace.dart';
import '../../../base/gaps.dart';
import '../../../base/line.dart';
import '../../../base/properties/properties.dart';

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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: PropertyPixelSegmented(
              accessor: PropertyAccessor(
                properties: workspaceStateModelPropertiesProvider,
                group: (properties) => properties.group,
                property: (properties) => properties.pixel,
                converter: intToIntConverter,
              ),
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

class InspectorColumns extends StatelessWidget {
  const InspectorColumns({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: withGapsBetween(
        children: children.map((e) => Expanded(child: e)).toList(growable: false),
        gap: const Gap(10),
      ),
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
        const HorizontalLine(),
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
      child: PropertyPixelSegmented(
        accessor: PropertyAccessor(
          properties: selectedWorkspaceItemModelPropertiesProvider,
          group: (properties) => properties.group,
          property: (properties) => properties.pixel,
          converter: intToIntConverter,
        ),
      ),
    );
  }
}

class WorkspaceInspectorItemPosition extends ConsumerWidget {
  const WorkspaceInspectorItemPosition({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InspectorRow(
      child: InspectorColumns(
        children: [
          PropertyTextBox(
            accessor: PropertyAccessor(
              properties: selectedWorkspaceItemModelPropertiesProvider,
              group: (properties) => properties.group,
              property: (properties) => properties.x,
              converter: intToStringConverter,
            ),
          ),
          PropertyTextBox(
            accessor: PropertyAccessor(
              properties: selectedWorkspaceItemModelPropertiesProvider,
              group: (properties) => properties.group,
              property: (properties) => properties.y,
              converter: intToStringConverter,
            ),
          )
        ],
      ),
    );
  }
}
