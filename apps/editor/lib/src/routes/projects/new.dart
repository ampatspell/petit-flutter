import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petit_editor/src/theme.dart';

import '../../blocks/projects/new_form.dart';
import '../screen/screen.dart';

class NewProjectScreen extends HookWidget {
  const NewProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      expandBody: true,
      body: Padding(
        padding: AppEdgeInsets.all10,
        child: NewProjectForm(),
      ),
    );
  }
}
