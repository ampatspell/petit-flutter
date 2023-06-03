import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../base/text_style.dart';

part 'three.g.dart';

class DevelopmentThreeScreen extends HookConsumerWidget {
  const DevelopmentThreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Zug'),
      ),
      content: const ScreenContent(),
    );
  }
}

class ScreenContent extends StatelessWidget {
  const ScreenContent({super.key});

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    return MountingProvider(
      create: (context) => Project(projectRef: firestore.collection('projects').doc('8PkLJa7AKtcBRkjPoCrg')),
      builder: (context, child) {
        return Observer(builder: (context) {
          final project = context.watch<Project>();
          if (project.isLoaded) {
            return child!;
          }
          return const SizedBox.shrink();
        });
      },
      child: const Loaded(),
    );
  }
}

class Loaded extends StatelessWidget {
  const Loaded({super.key});

  @override
  Widget build(BuildContext context) {
    final project = context.watch<Project>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton(
          child: const Text('Toggle'),
          onPressed: project.toggleReference,
        ),
        const Gap(10),
        const ProjectDetails(),
        const Gap(20),
        const Mounted(),
      ],
    );
  }
}

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final project = context.watch<Project>();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultFluentTextStyle(
            resolve: (typography) => typography.subtitle,
            child: const Text('Project:'),
          ),
          const Gap(5),
          Text('id: ${project.doc.reference?.id}'),
          Text('Name: ${project.doc.content?.name}'),
        ],
      );
    });
  }
}

class Nodes extends StatelessWidget {
  const Nodes({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final project = context.watch<Project>();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultFluentTextStyle(
            resolve: (typography) => typography.subtitle,
            child: const Text('Nodes:'),
          ),
          const Gap(5),
          for (final model in project.nodes.content) Text(model.toString()),
          if (project.nodes.content.isEmpty) const Text('No nodes'),
        ],
      );
    });
  }
}

class Mounted extends StatelessWidget {
  const Mounted({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultFluentTextStyle(
            resolve: (typography) => typography.subtitle,
            child: const Text('Mounted:'),
          ),
          const Gap(5),
          for (final model in mounted) Text(model.toString()),
        ],
      );
    });
  }
}

class Project extends _Project with _$Project {
  Project({required super.projectRef});

  @override
  String toString() {
    return 'Project{doc: ${doc.content}, nodes: ${nodes.content}}';
  }
}

abstract class _Project with Store, Mountable {
  _Project({
    required this.projectRef,
  });

  @observable
  MapDocumentReference projectRef;

  @action
  void toggleReference() {
    if (projectRef.id == '8PkLJa7AKtcBRkjPoCrg') {
      projectRef = projectRef.parent.doc('Mvv2Q6iv7CwHNsftfhYW');
    } else {
      projectRef = projectRef.parent.doc('8PkLJa7AKtcBRkjPoCrg');
    }
  }

  @override
  Iterable<Mountable> get mountable => [doc, nodes];

  bool get isLoaded => doc.isLoaded && nodes.isLoaded;

  late final ModelReference<ProjectDoc> doc = ModelReference(
    name: 'project-doc',
    reference: () => projectRef,
    create: (doc) => ProjectDoc(doc: doc),
  );

  late final ModelsQuery<ProjectNodeDoc> nodes = ModelsQuery(
    query: () => projectRef.collection('nodes'),
    create: (doc) => ProjectNodeDoc(doc: doc),
  );
}

class ProjectDoc extends _ProjectDoc with _$ProjectDoc {
  ProjectDoc({required super.doc});

  String? get name => doc['name'] as String?;

  @override
  String toString() {
    return 'ProjectDoc{doc: $doc}';
  }
}

abstract class _ProjectDoc with Store, Mountable implements DocumentModel {
  _ProjectDoc({
    required this.doc,
  });

  @override
  final Document doc;

  @override
  Iterable<Mountable> get mountable => [];
}

class ProjectNodeDoc extends _ProjectNodeDoc with _$ProjectNodeDoc {
  ProjectNodeDoc({required super.doc});

  @override
  String toString() {
    return 'ProjectNodeDoc{doc: $doc}';
  }
}

abstract class _ProjectNodeDoc with Store, Mountable implements DocumentModel {
  _ProjectNodeDoc({
    required this.doc,
  });

  @override
  final Document doc;

  @override
  Iterable<Mountable> get mountable => [];
}
