import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/doc.dart';
import '../../models/properties.dart';
import '../../providers/base.dart';
import '../base/async_values_loader.dart';
import '../base/properties.dart';

part 'two.freezed.dart';

part 'two.g.dart';

class DevelopmentTwoScreen extends HookConsumerWidget {
  const DevelopmentTwoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Two'),
      ),
      content: AsyncValuesLoader(
        providers: [
          thingModelStreamProvider,
        ],
        child: const ThingContent(),
      ),
    );
  }
}

class ThingContent extends ConsumerWidget {
  const ThingContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThingDescription(),
        Gap(10),
        ThingForm(),
      ],
    );
  }
}

class ThingForm extends ConsumerWidget {
  const ThingForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PropertiesWidget(
      properties: thingModelPropertiesProvider,
    );
  }
}

class ThingDescription extends ConsumerWidget {
  const ThingDescription({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thing = ref.watch(thingModelProvider);
    // final properties = ref.watch(thingModelPropertiesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${thing.name}'),
        // const Gap(10),
        // Text('Properties: $properties'),
        const Gap(10),
        FilledButton(
          child: const Text('Toggle name'),
          onPressed: () {
            late final String name;
            if (thing.name == 'One') {
              name = 'Two';
            } else {
              name = 'One';
            }
            ref.read(thingModelProvider).updateName(name);
          },
        ),
        const Gap(10),
        FilledButton(
          child: const Text('Clear name'),
          onPressed: () {
            ref.read(thingModelProvider).updateName(null);
          },
        ),
        const Gap(10),
        FilledButton(
          child: const Text('Toggle group disabled'),
          onPressed: () {
            ref.read(groupDisabledProvider.notifier).toggle();
          },
        ),
      ],
    );
  }
}

@freezed
class ThingModel with _$ThingModel implements HasDoc {
  const factory ThingModel({
    required Doc doc,
  }) = _ThingModel;

  const ThingModel._();

  String get name => doc['name'] as String? ?? '';

  String get identifier => doc['identifier'] as String? ?? '';

  int get x => doc['x'] as int? ?? 0;

  int get y => doc['y'] as int? ?? 0;

  Future<void> updateName(String? name) async {
    await doc.merge({'name': name});
  }

  Future<void> updateIdentifier(String? identifier) async {
    await doc.merge({'identifier': identifier});
  }

  void updateX(int value) async {
    await doc.merge({'x': value});
  }

  void updateY(int value) async {
    await doc.merge({'y': value});
  }
}

@Riverpod(dependencies: [firebaseServices])
Stream<ThingModel> thingModelStream(ThingModelStreamRef ref) {
  final firestore = ref.watch(firebaseServicesProvider.select((value) => value.firestore));
  return firestore.doc('development/thing').snapshots(includeMetadataChanges: true).map((event) {
    return ThingModel(doc: Doc.fromSnapshot(event, isOptional: true));
  });
}

@Riverpod(dependencies: [thingModelStream])
ThingModel thingModel(ThingModelRef ref) {
  return ref.watch(thingModelStreamProvider.select((value) => value.requireValue));
}

@Riverpod(dependencies: [thingModel])
Properties thingModelProperties(ThingModelPropertiesRef ref) {
  final model = ref.watch(thingModelProvider);
  return Properties(groups: [
    PropertyGroup(
      label: 'Position',
      properties: [
        Property.integerTextBox(
          value: model.x,
          update: model.updateX,
          validator: positiveInteger,
        ),
        Property.integerTextBox(
          value: model.y,
          update: model.updateY,
          validator: positiveInteger,
        ),
      ],
    ),
    PropertyGroup(
      label: 'Name',
      properties: [
        Property.stringTextBox(
          value: model.name,
          update: model.updateName,
          validator: stringNotEmpty,
        ),
      ],
    ),
    PropertyGroup(
      label: 'Identifier',
      properties: [
        Property.stringTextBox(
          value: model.identifier,
          update: model.updateIdentifier,
          validator: stringNotEmpty,
        ),
      ],
    ),
  ]);
}

@Riverpod(dependencies: [])
class GroupDisabled extends _$GroupDisabled {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}
