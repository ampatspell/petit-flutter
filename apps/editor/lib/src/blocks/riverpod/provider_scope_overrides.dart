import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsyncValueOverrideProvider<T> {
  final AutoDisposeProvider<T> provider;
  final AsyncValue<T> value;

  const AsyncValueOverrideProvider({
    required this.provider,
    required this.value,
  });
}

class ScopeOverrideBuilder<T> {
  final AutoDisposeProvider<T> provider;

  ScopeOverrideBuilder(this.provider);

  AsyncValueOverrideProvider<T> withAsyncValue(AsyncValue<T> value) {
    return AsyncValueOverrideProvider(provider: provider, value: value);
  }
}

ScopeOverrideBuilder<T> scopeOverride<T>(AutoDisposeProvider<T> provider) => ScopeOverrideBuilder(provider);

class ProviderScopeOverrides extends StatelessWidget {
  final List<AsyncValueOverrideProvider<dynamic>> overrides;
  final Widget child;

  const ProviderScopeOverrides({
    super.key,
    required this.overrides,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final hasErrors = overrides.where((element) => element.value.hasError);
    if (hasErrors.isNotEmpty) {
      return Text('Errors: $hasErrors');
    }

    final loading = overrides.where((element) => element.value.isLoading);
    if (loading.isNotEmpty) {
      return const Text('Loading…');
    }

    return ProviderScope(
      overrides: overrides.map((e) {
        return e.provider.overrideWithValue(e.value.value!);
      }).toList(growable: false),
      child: child,
    );
  }
}
