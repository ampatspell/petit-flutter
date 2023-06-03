import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../app/router.dart';

class Load<T extends Loadable> extends StatelessObserverWidget {
  const Load({
    super.key,
    required this.child,
    this.onMissing,
  });

  final Widget child;
  final void Function(BuildContext context)? onMissing;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<T>();
    final isLoaded = model.isLoaded;
    if (isLoaded) {
      if (model.isMissing && onMissing != null) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          final context = rootNavigatorKey.currentContext!;
          onMissing!(context);
        });
        return const SizedBox.shrink();
      } else {
        return child;
      }
    }
    return const SizedBox.shrink();
  }
}
