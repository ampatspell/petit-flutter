import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

import '../base/properties/properties.dart';
import '../loading.dart';

part 'two.g.dart';

class DevelopmentTwoScreen extends StatelessWidget {
  const DevelopmentTwoScreen({super.key});

  FirebaseFirestore get _firestore => it.get();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Two'),
      ),
      content: MountingProvider<Main>(
        create: (context) => Main(reference: _firestore.doc('development/thing')),
        child: const Load<Main>(
          child: DevelopmentTwoScreenContent(),
        ),
      ),
    );
  }
}

Observable<bool> show = Observable(true);

class DevelopmentTwoScreenContent extends StatelessObserverWidget {
  const DevelopmentTwoScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Description(),
        const Gap(10),
        FilledButton(
          child: const Text('Toggle form'),
          onPressed: () {
            runInAction(() {
              show.value = !show.value;
            });
          },
        ),
        const Gap(10),
        if (show.value) _Form(),
      ],
    );
  }
}

class _Form extends StatelessObserverWidget {
  @override
  Widget build(BuildContext context) {
    final groups = context.watch<Main>().thing.propertyGroups;
    return Provider(
      create: (context) => groups,
      child: const PropertyGroupsForm(),
    );
  }
}

class _Description extends StatelessObserverWidget {
  @override
  Widget build(BuildContext context) {
    final main = context.watch<Main>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(main.thing.toString()),
        const Gap(10),
        FilledButton(
          child: const Text('Toggle name'),
          onPressed: main.toggleName,
        ),
      ],
    );
  }
}

class Main = _Main with _$Main;

abstract class _Main with Store, Mountable implements Loadable {
  _Main({
    required this.reference,
  });

  @override
  Iterable<Mountable> get mountable => [_thing];

  final MapDocumentReference reference;

  late final ModelReference<Thing> _thing = ModelReference(
    reference: () => reference,
    create: Thing.new,
  );

  @override
  bool get isLoaded => _thing.isLoaded;

  @override
  bool get isMissing => _thing.isMissing;

  Thing get thing => _thing.content!;

  @action
  void toggleName() {
    if (thing.name.value == 'Hello') {
      thing.name.setEditorValue('Zeeba');
    } else {
      thing.name.setEditorValue('Hello');
    }
  }

  @override
  String toString() {
    return 'Main{thing: ${_thing.content}}';
  }
}

class Thing = _Thing with _$Thing;

abstract class _Thing with Store, Mountable implements DocumentModel {
  _Thing(this.doc);

  @override
  final Document doc;

  late final Property<String, String> name = Property.documentModel(
    this,
    key: 'name',
    initial: '',
    validator: stringNotBlankValidator,
    presentation: stringTextBoxPresentation,
  );

  late final Property<String, String> identifier = Property.documentModel(
    this,
    key: 'identifier',
    initial: '',
    validator: stringNotBlankValidator,
    presentation: stringTextBoxPresentation,
  );

  late final Property<int, String> x = Property.documentModel(
    this,
    key: 'x',
    initial: 0,
    validator: intIsPositiveValidator,
    presentation: integerTextBoxPresentation,
  );

  late final Property<int, String> y = Property.documentModel(
    this,
    key: 'y',
    initial: 0,
    validator: intIsPositiveValidator,
    presentation: integerTextBoxPresentation,
  );

  late final PropertyGroups propertyGroups = PropertyGroups([
    PropertyGroup(
      name: 'Name',
      properties: [name],
    ),
    PropertyGroup(
      name: 'Identifier',
      properties: [identifier],
    ),
    PropertyGroup(
      name: 'Position',
      properties: [x, y],
    ),
  ]);

  @override
  String toString() {
    return 'Thing{name: $name, identifier: $identifier, x: $x, y: $y}';
  }
}
