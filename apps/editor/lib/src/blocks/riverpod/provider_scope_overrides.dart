import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/base.dart';

abstract class ScopeOverride<T> {
  AutoDisposeProvider<T> get provider;

  bool get hasError;

  bool get hasValue;

  Object? get error;

  StackTrace? get stackTrace;

  T? get value;
}

class AsyncValueScopeOverride<T> implements ScopeOverride<T> {
  final AutoDisposeProvider<T> _provider;
  final AsyncValue<T> _value;

  const AsyncValueScopeOverride({
    required AutoDisposeProvider<T> provider,
    required AsyncValue<T> value,
  })  : _value = value,
        _provider = provider;

  @override
  AutoDisposeProvider<T> get provider => _provider;

  @override
  Object? get error => _value.error;

  @override
  StackTrace? get stackTrace => _value.stackTrace;

  @override
  bool get hasError => _value.hasError;

  @override
  bool get hasValue => _value.hasValue;

  @override
  T? get value => _value.value;

  @override
  String toString() {
    return 'AsyncValueScopeOverride{provider: $_provider, value: $_value}';
  }
}

class ScopeOverrideBuilder<T> {
  final AutoDisposeProvider<T> provider;

  ScopeOverrideBuilder(this.provider);

  AsyncValueScopeOverride<T> withAsyncValue(AsyncValue<T> value) {
    return AsyncValueScopeOverride(provider: provider, value: value);
  }

  AsyncValueScopeOverride<T> withValue(T value) {
    return AsyncValueScopeOverride(provider: provider, value: AsyncValue.data(value));
  }
}

ScopeOverrideBuilder<T> overrideProvider<T>(AutoDisposeProvider<T> provider) => ScopeOverrideBuilder(provider);

class ProviderScopeOverridesLoading extends StatelessWidget {
  const ProviderScopeOverridesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class ProviderScopeOverridesError extends StatelessWidget {
  final List<ScopeOverride<dynamic>> errors;

  const ProviderScopeOverridesError({
    super.key,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var error in errors) ...[
          Text([
            error.error.toString(),
            error.stackTrace.toString(),
          ].join('\n')),
          const Gap(20),
        ],
      ],
    );
  }
}

class ProviderScopeOverridesScaffold extends StatelessWidget {
  final String? title;
  final Widget child;

  const ProviderScopeOverridesScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: title != null
          ? PageHeader(
              title: Text(title!),
            )
          : null,
      children: [
        child,
      ],
    );
  }
}

class ProviderScopeOverrides extends ConsumerWidget {
  final List<ScopeOverride<dynamic>> Function(BuildContext context, WidgetRef ref) overrides;
  final Widget child;
  final Object? parent;

  const ProviderScopeOverrides({
    super.key,
    this.parent,
    required this.overrides,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final built = overrides(context, ref);

    Widget ensureScaffold(String? title, Widget child) {
      final scaffold = context.findAncestorWidgetOfExactType<ScaffoldPage>();
      if (scaffold == null) {
        child = ProviderScopeOverridesScaffold(
          title: title,
          child: child,
        );
      } else {
        child = Padding(
          padding: const EdgeInsets.all(10.0),
          child: child,
        );
      }
      return child;
    }

    final errors = built.where((element) => element.hasError).toList(growable: false);
    if (errors.isNotEmpty) {
      return ensureScaffold('Something went wrong', ProviderScopeOverridesError(errors: errors));
    }

    final loading = built.where((element) => !element.hasValue).toList(growable: false);
    if (loading.isNotEmpty) {
      return ensureScaffold(null, const ProviderScopeOverridesLoading());
    }

    return ProviderScope(
      overrides: built.map((e) {
        return e.provider.overrideWithValue(e.value!);
      }).toList(growable: false),
      child: Consumer(
        builder: (context, ref, child) {
          final container = ProviderScope.containerOf(context);
          final logging = ref.read(loggingObserverProvider);
          for (var override in built) {
            logging.didOverrideProvider(
              override.provider,
              override.value!,
              container,
              parent?.runtimeType.toString(),
            );
          }
          return child!;
        },
        child: child,
      ),
    );
  }
}
