import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:mobx/mobx.dart';

import '../base/measurable.dart';

Observable<bool> show = Observable(false);
Observable<Size?> size = Observable(null);

class DevelopmentOneScreen extends StatelessObserverWidget {
  const DevelopmentOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              runInAction(() {
                show.value = !show.value;
              });
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

class ToolsWidget extends StatelessWidget {
  const ToolsWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final measurable = MeasurableWidget(
      onSize: (measuredSize) => runInAction(() {
        size.value = measuredSize;
      }),
      child: child,
    );

    const offset = 5.0;

    if (size.value == null) {
      return Offstage(
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
