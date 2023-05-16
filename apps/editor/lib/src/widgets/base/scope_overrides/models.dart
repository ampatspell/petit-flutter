part of 'scope_overrides.dart';

abstract class OverrideLoader<T> {
  const OverrideLoader({
    required AutoDisposeProvider<T>? provider,
  }) : _provider = provider;

  final AutoDisposeProvider<T>? _provider;

  _AsyncValueLoader<T> _toAsyncValue(WidgetRef ref);
}

class _AsyncValueLoader<T> extends OverrideLoader<T> {
  const _AsyncValueLoader({
    required super.provider,
    required AsyncValue<T> value,
  }) : _value = value;

  final AsyncValue<T> _value;

  @override
  _AsyncValueLoader<T> _toAsyncValue(WidgetRef ref) {
    return this;
  }

  @override
  String toString() {
    return 'AsyncValueLoader{provider: $_provider, value: $_value}';
  }
}

class _ProviderListenableLoader<T> extends OverrideLoader<T> {
  const _ProviderListenableLoader({
    required super.provider,
    required ProviderListenable<AsyncValue<T>> listenable,
  }) : _listenable = listenable;

  final ProviderListenable<AsyncValue<T>> _listenable;

  @override
  _AsyncValueLoader<T> _toAsyncValue(WidgetRef ref) {
    final value = ref.watch(_listenable);
    return _AsyncValueLoader(
      provider: _provider,
      value: value,
    );
  }

  @override
  String toString() {
    return 'ProviderListenableLoader{provider: $_provider, listenable: $_listenable}';
  }
}

class ScopeOverrideBuilder<T> {
  ScopeOverrideBuilder(this._provider);

  final AutoDisposeProvider<T> _provider;

  OverrideLoader<T> withAsyncValue(AsyncValue<T> value) {
    return _AsyncValueLoader(
      provider: _provider,
      value: value,
    );
  }

  OverrideLoader<T> withValue(T value) {
    return _AsyncValueLoader(
      provider: _provider,
      value: AsyncValue.data(value),
    );
  }

  OverrideLoader<T> withListenable(ProviderListenable<AsyncValue<T>> listenable) {
    return _ProviderListenableLoader(
      provider: _provider,
      listenable: listenable,
    );
  }
}

ScopeOverrideBuilder<T> overrideProvider<T>(AutoDisposeProvider<T> provider) => ScopeOverrideBuilder(provider);

OverrideLoader<T> loadAsyncValue<T>(AsyncValue<T> value) {
  return _AsyncValueLoader<T>(
    provider: null,
    value: value,
  );
}
