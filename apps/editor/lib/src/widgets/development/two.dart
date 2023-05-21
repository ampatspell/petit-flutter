import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../base/segmented.dart';

class DevelopmentTwoScreen extends HookConsumerWidget {
  const DevelopmentTwoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState<int?>(4);
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Two'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Segmented<int>(
              segments: [
                const Segment(label: '1', value: 1),
                const Segment(label: '2', value: 2),
                const Segment(label: '4', value: 4),
                const Segment(label: '8', value: 8),
              ],
              selected: selected.value,
              onSelect: (value) => selected.value = value,
            ),
          ),
        ],
      ),
    );
  }
}
