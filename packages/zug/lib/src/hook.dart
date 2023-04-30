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
  return use(SubscribableHook<T>(
    model: model,
    update: update,
  ));
}

class SubscribableHook<T extends Subscribable> extends Hook<T> {
  final T model;
  final SubscribableUpdate<T> update;

  const SubscribableHook({
    required this.model,
    required this.update,
  });

  @override
  HookState<T, Hook<T>> createState() {
    return SubscribableHookState(model: model, update: update);
  }
}

class SubscribableHookState<T extends Subscribable> extends HookState<T, SubscribableHook<T>> {
  final T model;
  final SubscribableUpdate<T> update;
  late final Subscription subscription;

  SubscribableHookState({
    required this.model,
    required this.update,
  }) {
    subscription = model.subscribe();
  }

  @override
  void didUpdateHook(SubscribableHook oldHook) {
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
