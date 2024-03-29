import 'package:fluent_ui/fluent_ui.dart';

import 'form.dart';

class NewProjectScreen extends StatelessWidget {
  const NewProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('New project'),
      ),
      content: const NewProjectForm(),
    );
  }
}
