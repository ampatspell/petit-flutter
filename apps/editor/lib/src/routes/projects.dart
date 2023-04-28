import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:petit_editor/src/blocks/projects/list.dart';

import 'router.dart';

class ProjectsScreen extends HookWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      backgroundColor: Colors.white,
      endSidebar: Sidebar(
        shownByDefault: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Expanded(
                  child: Container(
                color: Colors.redAccent,
              )),
            ],
          );
        },
        minWidth: 200,
      ),
      child: Builder(builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            automaticallyImplyLeading: false,
            title: const Text("Projects"),
            actions: [
              ToolBarIconButton(
                label: 'Sidebar',
                icon: const MacosIcon(CupertinoIcons.archivebox_fill),
                onPressed: () => MacosWindowScope.of(context).toggleEndSidebar(),
                showLabel: false,
              ),
              ToolBarIconButton(
                label: 'Add project',
                icon: const MacosIcon(Icons.add),
                showLabel: false,
                onPressed: () => NewProjectRoute().go(context),
              ),
            ],
          ),
          children: [
            ContentArea(builder: (context, scrollController) {
              return ProjectsList(
                onSelect: (ref) {
                  ProjectRoute(projectId: ref.id).go(context);
                },
              );
            }),
          ],
        );
      }),
    );
  }
}
