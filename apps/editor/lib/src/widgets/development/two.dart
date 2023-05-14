import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DevelopmentTwoScreen extends HookConsumerWidget {
  const DevelopmentTwoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Two'),
      ),
      content: const SizedBox.shrink(),
    );
  }
}
