import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/doc.dart';
import '../../../../providers/project/workspace/editor.dart';
import '../../../../providers/project/workspace/workspace.dart';
import '../../../base/fields/fields.dart';
import '../../../base/segmented.dart';

class WorkspaceInspector extends ConsumerWidget {
  const WorkspaceInspector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspacePixel = ref.watch(workspaceStateModelProvider.select((value) => value.pixel));

    void setWorkspacePixel(int value) {
      ref.read(workspaceStateModelProvider).updatePixel(value);
    }

    final item = ref.watch(selectedWorkspaceItemModelProvider);
    // final node = ref.watch(selectedNodeModelProvider);

    void setItemPixel(int value) {
      item!.updatePixel(value);
    }

    Widget pixels(int value, ValueChanged<int> onChange) {
      return Segmented<int>(
        segments: [
          const Segment(label: '1', value: 1),
          const Segment(label: '2', value: 2),
          const Segment(label: '4', value: 4),
          const Segment(label: '8', value: 8),
          const Segment(label: '16', value: 16),
        ],
        selected: value,
        onSelect: (value) => onChange(value),
      );
    }

    return Container(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Workspace'),
            const Gap(10),
            Text('Pixel: $workspacePixel'),
            const Gap(10),
            // pixels(workspacePixel, setWorkspacePixel),
            FieldPixels(provider: workspacePixelFieldProvider),
            const Gap(10),
            FieldTextBox(provider: workspacePixelFieldProvider),
            if (item != null) ...[
              const Gap(20),
              const Text('Item'),
              const Gap(10),
              Text('Position: ${item.x} ${item.y}'),
              const Gap(10),
              Text('Pixel: ${item.pixel}'),
              const Gap(10),
              pixels(item.pixel, setItemPixel),
            ]
          ],
        ),
      ),
    );
  }
}
