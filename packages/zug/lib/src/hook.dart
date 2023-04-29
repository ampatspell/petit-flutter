import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'stream.dart';

T useSubscribable<T extends Subscribable>(T model) {
  return use(SubscribableHook<T>(model: model));
}

class SubscribableHook<T extends Subscribable> extends Hook<T> {
  final T model;

  const SubscribableHook({
    required this.model,
  });

  @override
  HookState<T, Hook<T>> createState() => SubscribableHookState(model: model);
}

class SubscribableHookState<T extends Subscribable> extends HookState<T, SubscribableHook<T>> {
  late final T model;
  late final Subscription subscription;

  SubscribableHookState({
    required this.model,
  }) {
    subscription = model.subscribe();
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
