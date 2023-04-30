import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:mobx/mobx.dart';

class DevelopmentScreen extends HookWidget {
  const DevelopmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Development'),
      ),
      content: Row(),
    );
  }
}
