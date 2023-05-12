import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class ScopeOverride<T> {
  bool get hasError;

  Object? get error;

  bool get isLoading;

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
  bool get isLoading => _value.isLoading;

  @override
  Object? get error => _value.error;

  @override
  bool get hasError => _value.hasError;

  @override
  Override asOverride() {
    return _provider.overrideWithValue(_value.value as T);
  }

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
}

ScopeOverrideBuilder<T> overrideProvider<T>(AutoDisposeProvider<T> provider) => ScopeOverrideBuilder(provider);

class ProviderScopeOverrides extends StatelessWidget {
  final List<ScopeOverride<dynamic>> overrides;
  final Widget child;

  const ProviderScopeOverrides({
    super.key,
    required this.overrides,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final hasErrors = overrides.where((element) => element.hasError);
    if (hasErrors.isNotEmpty) {
      return Text('Errors: $hasErrors');
    }

    final loading = overrides.where((element) => element.isLoading);
    if (loading.isNotEmpty) {
      return const Text('Loading…');
    }

    return ProviderScope(
      overrides: overrides.map((e) => e.asOverride()).toList(growable: false),
      child: child,
    );
  }
}
