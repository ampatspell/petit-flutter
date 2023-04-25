import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petit_editor/src/get_it.dart';
import 'package:petit_editor/src/theme.dart';

import 'src/area/area.dart';
import 'src/blocks/separator.dart';
import 'src/stores/app.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petit editor',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const Initialized(),
    );
  }
}

class Initialized extends StatelessWidget {
  const Initialized({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getItReady,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return ListProjectsPage(
              onSelect: (projectRef) {
                print(projectRef);
              },
            );
          default:
            return const Material(
              child: Center(
                child: Text('Loading…'),
              ),
            );
        }
      },
    );
  }
}

class ListProjectsPage extends HookWidget {
  final void Function(DocumentReference<Map<String, dynamic>> projectRef) onSelect;

  const ListProjectsPage({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final firestore = it.get<FirebaseFirestore>();
    final ref = firestore.collection('projects');
    final stream = useStream(ref.snapshots());
    if (stream.hasData) {
      final data = stream.data!;
      if (data.size == 0) {
        return const Center(
          child: Text('No projects yet'),
        );
      } else {
        return Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: AppEdgeInsets.symmetric15x10,
                child: Text(
                  'Projects',
                  style: AppTextStyle.regularBold,
                ),
              ),
              const Separator(),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final doc = data.docs[index];
                    final map = doc.data();
                    return InkWell(
                      onTap: () => onSelect(doc.reference),
                      child: Padding(
                        padding: AppEdgeInsets.symmetric15x10,
                        child: Text(map['name']),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Separator(),
                  itemCount: data.size,
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return const Material(
        child: Center(
          child: Text('Loading…'),
        ),
      );
    }
  }
}

class DevPage extends HookWidget {
  const DevPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = it.get<App>();
    final area = useState(app.createEditorArea());
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AreaEditor(
              area: area.value,
            ),
          ),
        ],
      ),
    );
  }
}
