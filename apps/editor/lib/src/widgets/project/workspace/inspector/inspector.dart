import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/project/workspace/editor.dart';
import '../../../base/gaps.dart';
import '../../../base/line.dart';

class WorkspaceInspector extends ConsumerWidget {
  const WorkspaceInspector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 250,
      color: Colors.white,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: WorkspaceInspectorContent(),
            ),
          ),
          HorizontalLine(),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: PropertyPixelSegmented(
          //     accessor: PropertyAccessor.integer(
          //       properties: workspaceStateModelPropertiesProvider,
          //       group: (properties) => properties.group,
          //       property: (properties) => properties.pixel,
          //     ),
          //   ),
          // ),
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
    final hasProperties = ref.watch(selectedWorkspaceItemModelProvider.select((value) => value != null));
    final hasNode = ref.watch(selectedNodeModelProvider.select((value) => value != null));

    return InspectorContainer(
      children: [
        if (hasProperties) ...[
          // const WorkspaceInspectorItemPosition(),
          // const WorkspaceInspectorItemPixel(),
        ],
        if (hasNode) ...[
          const WorkspaceInspectorNode(),
        ]
      ],
    );
  }
}

class WorkspaceInspectorNode extends ConsumerWidget {
  const WorkspaceInspectorNode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(selectedNodeModelProvider.select((value) => value?.type));
    if (type == 'box') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InspectorRow(
            child: Text(type ?? 'Nop'),
          ),
        ],
      );
    }
    throw UnsupportedError(type.toString());
  }
}
//
// class WorkspaceInspectorItemPixel extends ConsumerWidget {
//   const WorkspaceInspectorItemPixel({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return InspectorRow(
//       child: PropertyPixelSegmented(
//         accessor: PropertyAccessor.integer(
//           properties: selectedWorkspaceItemModelPropertiesProvider,
//           group: (properties) => properties.group,
//           property: (properties) => properties.pixel,
//         ),
//       ),
//     );
//   }
// }
//
// class WorkspaceInspectorItemPosition extends ConsumerWidget {
//   const WorkspaceInspectorItemPosition({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return InspectorRow(
//       child: InspectorColumns(
//         children: [
//           PropertyTextBox(
//             accessor: PropertyAccessor.integerToString(
//               properties: selectedWorkspaceItemModelPropertiesProvider,
//               group: (properties) => properties.group,
//               property: (properties) => properties.x,
//             ),
//           ),
//           PropertyTextBox(
//             accessor: PropertyAccessor.integerToString(
//               properties: selectedWorkspaceItemModelPropertiesProvider,
//               group: (properties) => properties.group,
//               property: (properties) => properties.y,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
