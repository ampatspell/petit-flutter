import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

class LoggingObserver implements ProviderObserver {
  LoggingObserver();

  Object _name(ProviderBase<Object?> provider) {
    return provider.name ?? provider.runtimeType;
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('[add] ${_name(provider)}: $value');
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('[dispose] ${_name(provider)}');
    }
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('[updated] ${_name(provider)}: $previousValue → $newValue');
    }
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
