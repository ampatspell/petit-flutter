import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'stream.dart';

typedef SubscribableUpdate<T extends Subscribable> = void Function(
  T state,
  T next,
);

T useSubscribable<T extends Subscribable>({
  required T model,
  required SubscribableUpdate<T> update,
}) {
  return use(_SubscribableHook<T>(
    model: model,
    update: update,
  ));
}

class _SubscribableHook<T extends Subscribable> extends Hook<T> {
  final T model;
  final SubscribableUpdate<T> update;

  const _SubscribableHook({
    required this.model,
    required this.update,
  });

  @override
  HookState<T, Hook<T>> createState() {
    return _SubscribableHookState(model: model, update: update);
  }
}

class _SubscribableHookState<T extends Subscribable> extends HookState<T, _SubscribableHook<T>> {
  final T model;
  final SubscribableUpdate<T> update;
  late final Subscription subscription;

  _SubscribableHookState({
    required this.model,
    required this.update,
  }) {
    subscription = model.subscribe();
  }

  @override
  void didUpdateHook(_SubscribableHook oldHook) {
    update(model, hook.model);
  }

  @override
  T build(BuildContext context) {
    return model;
  }

  @override
  void dispose() {
    subscription.close();
  }
}
