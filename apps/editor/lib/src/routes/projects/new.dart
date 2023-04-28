import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../blocks/projects/new_form.dart';

class NewProjectScreen extends HookWidget {
  const NewProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      header: PageHeader(
        title: Text('New project'),
      ),
      content: NewProjectForm(),
    );
  }
}
