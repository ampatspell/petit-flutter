import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'stream.g.dart';

abstract class Subscription {
  void close();
}

abstract class Subscribable {
  Subscription subscribe();

  get isSubscribed;
}

class CallbackSubscription implements Subscription {
  VoidCallback? _callback;

  CallbackSubscription(this._callback);

  @override
  void close() {
    if (_callback == null) {
      return;
    }
    _callback!();
    _callback = null;
  }
}

class StreamSubscriptions<T> extends _StreamSubscriptions<T> {
  StreamSubscriptions({
    required super.subscribe,
    required super.onEvent,
  });
}

abstract class _StreamSubscriptions<T> with Store implements Subscribable {
  final Stream<T> Function() _subscribe;
  final void Function(T event) _onEvent;
  Stream<T>? _stream;
  StreamSubscription<T>? _subscription;
  int _subscriptions = 0;

  @override
  @observable
  bool isSubscribed = false;

  _StreamSubscriptions({
    required Stream<T> Function() subscribe,
    required void Function(T event) onEvent,
  })  : _subscribe = subscribe,
        _onEvent = onEvent;

  @override
  @action
  Subscription subscribe() {
    if (_stream == null) {
      _stream = _subscribe();
      _subscription = _stream!.listen(_onEvent);
      isSubscribed = true;
    }
    _subscriptions++;
    return CallbackSubscription(() => _unsubscribe());
  }

  @action
  void _unsubscribe() {
    _subscriptions--;
    if (_subscriptions == 0) {
      _subscription!.cancel();
      _subscription = null;
      _stream = null;
      isSubscribed = false;
    }
  }
}
