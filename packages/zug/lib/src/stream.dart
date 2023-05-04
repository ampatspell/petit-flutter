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

class StreamSubscriptions<T> extends _StreamSubscriptions<T> with _$StreamSubscriptions {
  StreamSubscriptions({
    required super.subscribe,
    required super.onEvent,
    required super.onSubscribed,
    required super.onWillRefresh,
  });
}

var _streams = 0;

abstract class _StreamSubscriptions<T> with Store implements Subscribable {
  Stream<T> Function() _subscribe;
  final void Function(T event) _onEvent;
  final VoidCallback _onSubscribed;
  final VoidCallback _onWillRefresh;
  Stream<T>? _stream;
  StreamSubscription<T>? _subscription;
  int _subscriptions = 0;

  @override
  @observable
  bool isSubscribed = false;

  _StreamSubscriptions({
    required Stream<T> Function() subscribe,
    required void Function(T event) onEvent,
    required VoidCallback onSubscribed,
    required VoidCallback onWillRefresh,
  })  : _subscribe = subscribe,
        _onEvent = onEvent,
        _onSubscribed = onSubscribed,
        _onWillRefresh = onWillRefresh;

  @override
  @action
  Subscription subscribe() {
    if (_stream == null) {
      _stream = _subscribe();
      _subscription = _stream!.listen(_onEvent);
      isSubscribed = true;
      _onSubscribed();
      _streams++;
      // ignore: avoid_print
      print('subscribe (total $_streams)');
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
      _streams--;
      // ignore: avoid_print
      print('unsubscribe (total $_streams)');
    }
  }

  @action
  void replaceStream(Stream<T> Function() subscribe) {
    _subscribe = subscribe;
    if (isSubscribed) {
      _subscription!.cancel();
      _onWillRefresh();
      _subscription = subscribe().listen(_onEvent);
      // ignore: avoid_print
      print('resubscribe (total $_streams)');
    } else {
      _onWillRefresh();
    }
  }
}
