part of 'loaded_scope.dart';

class ScopeLoader<T> {
  final AutoDisposeProvider<T>? provider;
  final AsyncValue<T> value;

  const ScopeLoader({
    required this.provider,
    required this.value,
  });

  @override
  String toString() {
    return 'AsyncValueScopeOverride{provider: $provider, value: $value}';
  }
}

class ScopeLoaderBuilder<T> {
  final AutoDisposeProvider<T> provider;

  ScopeLoaderBuilder(this.provider);

  ScopeLoader<T> withLoadedValue(AsyncValue<T> value) {
    return ScopeLoader(
      provider: provider,
      value: value,
    );
  }

  ScopeLoader<T> withValue(T value) {
    return ScopeLoader(
      provider: provider,
      value: AsyncValue.data(value),
    );
  }
}

ScopeLoaderBuilder<T> overrideProvider<T>(AutoDisposeProvider<T> provider) => ScopeLoaderBuilder(provider);

ScopeLoader<T> loadAsyncValue<T>(AsyncValue<T> value) {
  return ScopeLoader<T>(
    provider: null,
    value: value,
  );
}
