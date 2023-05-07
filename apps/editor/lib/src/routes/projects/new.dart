import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewProjectScreen extends HookWidget {
  const NewProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('New project'),
      ),
      // content: const NewProjectForm(),
      content: const SizedBox.shrink(),
    );
  }
}
