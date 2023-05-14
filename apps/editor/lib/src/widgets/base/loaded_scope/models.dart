part of 'loaded_scope.dart';

class ScopeLoader<T> {
  const ScopeLoader({
    required this.provider,
    required this.value,
  });

  final AutoDisposeProvider<T>? provider;
  final AsyncValue<T> value;

  @override
  String toString() {
    return 'AsyncValueScopeOverride{provider: $provider, value: $value}';
  }
}

class ScopeLoaderBuilder<T> {
  ScopeLoaderBuilder(this.provider);

  final AutoDisposeProvider<T> provider;

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
