import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:gap/gap.dart';

import 'activatable/hook.dart';
import 'activatable/thing.dart';

class DevelopmentActivatableScreen extends HookWidget {
  const DevelopmentActivatableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = useState(ThingArgs(ok: true));
    final thing = useActivatable(
      args: args.value,
      build: (args) => Thing(
        args: args,
      ),
    );

    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Resizable'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            child: const Text('Toggle args'),
            onPressed: () {
              args.value = args.value.toggle();
            },
          ),
          const Gap(10),
          Text(args.value.toString()),
          const Gap(10),
          Text(thing.toString()),
        ],
      ),
    );
  }
}
