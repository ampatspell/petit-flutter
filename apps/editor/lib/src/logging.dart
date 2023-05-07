import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

class LoggingObserver implements ProviderObserver {
  LoggingObserver();

  Object _name(ProviderBase<Object?> provider) {
    return provider.name ?? provider.runtimeType;
  }

  _print(
    String prefix,
    ProviderBase<Object?> provider,
    ProviderContainer container, [
    String? message,
  ]) {
    if (kDebugMode) {
      final components = [
        '[$prefix]',
        '${container.depth}',
        _name(provider),
        if (message != null) message,
      ];
      print(components.join(' '));
    }
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _print('add', provider, container, '$value');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _print('dispose', provider, container);
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _print('update', provider, container, '$previousValue → $newValue');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('[fail] ${_name(provider)} $error, $stackTrace');
    }
  }
}
