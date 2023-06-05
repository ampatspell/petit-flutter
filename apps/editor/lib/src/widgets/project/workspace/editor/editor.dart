import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme.dart';
import '../../../../models/models.dart';

part 'box_item.dart';

part 'editor.g.dart';

part 'item.dart';

part 'item_container.dart';

part 'item_draggable.dart';

part 'item_resizable.dart';

class WorkspaceEditor extends StatelessObserverWidget {
  const WorkspaceEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<Workspace>();
    return GestureDetector(
      onTap: () => workspace.selection.clear(),
      child: Container(
        color: Grey.grey250,
        child: Stack(
          fit: StackFit.expand,
          children: [
            for (final item in workspace.items)
              ProxyProvider0(
                update: (context, value) => item,
                child: const _WorkspaceItem(),
              ),
          ],
        ),
      ),
    );
  }
}
