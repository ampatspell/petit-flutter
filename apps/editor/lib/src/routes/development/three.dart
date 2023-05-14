import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DevelopmentThreeScreen extends HookConsumerWidget {
  const DevelopmentThreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Three'),
      ),
      content: const SizedBox.shrink(),
    );
  }
}
