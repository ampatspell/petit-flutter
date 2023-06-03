import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../app/router.dart';

const placeholder = SizedBox.shrink();

class Load<T extends Loadable> extends StatelessWidget {
  const Load({
    super.key,
    this.child,
    this.onMissing,
  });

  final Widget? child;
  final void Function(BuildContext context)? onMissing;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final model = context.watch<T>();
        final isLoaded = model.isLoaded;
        if (isLoaded) {
          if (model.isMissing && onMissing != null) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              final context = rootNavigatorKey.currentContext!;
              onMissing!(context);
            });
            return placeholder;
          } else {
            return child ?? placeholder;
          }
        }
        return placeholder;
      },
    );
  }
}
