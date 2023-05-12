import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/base.dart';

abstract class ScopeOverride<T> {
  AutoDisposeProvider<T> get provider;

  bool get hasError;

  Object? get error;

  bool get isLoading;

  T? get value;

  Override asOverride();
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
  bool get isLoading => _value.isLoading;

  @override
  Object? get error => _value.error;

  @override
  bool get hasError => _value.hasError;

  @override
  T? get value => _value.value;

  @override
  Override asOverride() {
    final value = _value.value as T;
    return _provider.overrideWithValue(value);
  }

  @override
  String toString() {
    return 'AsyncValueScopeOverride{provider: $_provider, value: $_value}';
  }
}

class ValueScopeOverride<T> implements ScopeOverride<T> {
  final AutoDisposeProvider<T> _provider;
  final T _value;

  const ValueScopeOverride({
    required AutoDisposeProvider<T> provider,
    required T value,
  })  : _value = value,
        _provider = provider;

  @override
  final Object? error = null;

  @override
  final bool hasError = false;

  @override
  final bool isLoading = false;

  @override
  AutoDisposeProvider<T> get provider => _provider;

  @override
  T? get value => _value;

  @override
  Override asOverride() => _provider.overrideWithValue(_value);
}

class ScopeOverrideBuilder<T> {
  final AutoDisposeProvider<T> provider;

  ScopeOverrideBuilder(this.provider);

  AsyncValueScopeOverride<T> withAsyncValue(AsyncValue<T> value) {
    return AsyncValueScopeOverride(provider: provider, value: value);
  }

  ValueScopeOverride<T> withValue(T value) {
    return ValueScopeOverride(provider: provider, value: value);
  }
}

ScopeOverrideBuilder<T> overrideProvider<T>(AutoDisposeProvider<T> provider) => ScopeOverrideBuilder(provider);

class ProviderScopeOverrides extends ConsumerWidget {
  final List<ScopeOverride<dynamic>> Function(BuildContext context, WidgetRef ref) overrides;
  final Widget child;

  const ProviderScopeOverrides({
    super.key,
    required this.overrides,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final built = overrides(context, ref);

    final hasErrors = built.where((element) => element.hasError);
    if (hasErrors.isNotEmpty) {
      return Text('Errors: $hasErrors');
    }

    final loading = built.where((element) => element.isLoading);
    if (loading.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return ProviderScope(
      overrides: built.map((e) => e.asOverride()).toList(growable: false),
      child: Consumer(
        builder: (context, ref, child) {
          final container = ProviderScope.containerOf(context);
          final logging = ref.read(loggingObserverProvider);
          for (var override in built) {
            logging.didOverrideProvider(override.provider, override.value!, container);
          }
          return child!;
        },
        child: child,
      ),
    );
  }
}
