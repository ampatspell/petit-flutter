import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ModelsListView<P, T extends Object> extends StatelessObserverWidget {
  const ModelsListView({
    super.key,
    required this.models,
    required this.item,
    required this.placeholder,
  });

  final List<T> Function(P model) models;
  final Widget item;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    final models = this.models(context.watch<P>());
    final length = models.length;
    if (length == 0) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
        child: placeholder,
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) => Observer(builder: (context) {
          final model = models[index];
          return ProxyProvider0(
            update: (context, value) => model,
            child: item,
          );
        }),
        itemCount: length,
      );
    }
  }
}
