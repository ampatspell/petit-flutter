import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@Deprecated('replaced by ProviderScopeOverrides')
class AsyncValueWidget<T extends Object> extends ConsumerWidget {
  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T value) builder;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return value.when(
      data: (data) {
        return builder(context, data);
      },
      error: (error, stackTrace) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
        return Text(error.toString());
      },
      loading: () {
        return const Text('Loading…');
      },
    );
  }
}
