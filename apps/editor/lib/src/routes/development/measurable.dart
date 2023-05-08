import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

import '../../blocks/riverpod/measurable.dart';

class DevelopmentMeasurableScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final show = useState(false);
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Measurable'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            child: const Text('Toggle'),
            onPressed: () {
              show.value = !show.value;
            },
          ),
          if (show.value) ...[
            const Gap(10),
            ToolsWidget(
              child: Container(
                width: 320,
                height: 200,
                color: Colors.red.withAlpha(50),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class ToolsWidget extends HookWidget {
  final Widget child;

  const ToolsWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = useState<Size?>(null);

    MeasurableWidget measurable = MeasurableWidget(
      onSize: (measuredSize) {
        size.value = measuredSize;
      },
      child: child,
    );

    const offset = 5.0;

    if (size.value == null) {
      return Opacity(
        opacity: 0,
        child: measurable,
      );
    } else {
      return SizedBox(
        width: size.value!.width + (2 * offset),
        height: size.value!.height + (2 * offset),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Colors.red.withAlpha(50),
              constraints: const BoxConstraints.expand(),
            ),
            Positioned(
              top: offset,
              left: offset,
              child: measurable,
            )
          ],
        ),
      );
    }
  }
}
