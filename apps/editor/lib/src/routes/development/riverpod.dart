import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DevelopmentRiverpodScreen extends HookConsumerWidget {
  const DevelopmentRiverpodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Riverpod'),
      ),
      content: const Text('Riverpod'),
    );
  }
}
