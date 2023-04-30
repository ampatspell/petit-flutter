import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petit_zug/petit_zug.dart';

class ModelsListView<T extends FirestoreEntity> extends StatelessWidget {
  final FirestoreModels<T> models;
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
    return Observer(builder: (context) {
      final content = models.content;
      final length = content.length;
      if (models.isLoading) {
        return const SizedBox.shrink();
      } else {
        if (length == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
            child: placeholder,
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) => Observer(builder: (context) {
              final model = content[index];
              return itemBuilder(context, model);
            }),
            itemCount: length,
          );
        }
      }
    });
  }
}
