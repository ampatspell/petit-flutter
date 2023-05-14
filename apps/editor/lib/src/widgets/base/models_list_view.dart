import 'package:fluent_ui/fluent_ui.dart';

class ModelsListView<T extends Object> extends StatelessWidget {
  final List<T> models;
  final ListTile Function(BuildContext context, T model) itemBuilder;
  final Widget placeholder;

  const ModelsListView({
    super.key,
    required this.models,
    required this.itemBuilder,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final length = models.length;
    if (length == 0) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
        child: placeholder,
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          final model = models[index];
          return itemBuilder(context, model);
        },
        itemCount: length,
      );
    }
  }
}
