import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

class Loading<T extends Loadable> extends StatelessObserverWidget {
  const Loading({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    print('$this');

    final model = context.watch<T>();
    final isLoaded = model.isLoaded;
    if (isLoaded) {
      return child;
    }
    return const SizedBox.shrink();
  }
}
