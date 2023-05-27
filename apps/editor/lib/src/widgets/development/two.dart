import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/doc.dart';
import '../../models/properties.dart';
import '../../models/workspace.dart';
import '../../providers/base.dart';
import '../base/async_values_loader.dart';
import '../base/properties/properties.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyTextBox(
          accessor: PropertyAccessor.string(
            properties: thingModelPropertiesProvider,
            group: (properties) => properties.group,
            property: (properties) => properties.name,
          ),
        ),
        const Gap(10),
        PropertyTextBox(
          accessor: PropertyAccessor.string(
            properties: thingModelPropertiesProvider,
            group: (properties) => properties.group,
            property: (properties) => properties.identifier,
          ),
        ),
        const Gap(10),
        PropertyTextBox(
          accessor: PropertyAccessor.integerToString(
            properties: thingModelPropertiesProvider,
            group: (properties) => properties.group,
            property: (properties) => properties.x,
          ),
        ),
        const Gap(10),
        PropertyPixelSegmented(
          accessor: PropertyAccessor.integer(
            properties: thingModelPropertiesProvider,
            group: (properties) => properties.group,
            property: (properties) => properties.x,
          ),
        ),
      ],
    );
  }
}

class ThingDescription extends ConsumerWidget {
  const ThingDescription({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thing = ref.watch(thingModelProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${thing.name}'),
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

  int get x => doc['x'] as int? ?? 0;

  String get identifier => doc['identifier'] as String? ?? '';

  Future<void> updateName(String? name) async {
    await doc.merge({'name': name});
  }

  Future<void> updateIdentifier(String? identifier) async {
    await doc.merge({'identifier': identifier});
  }

  Future<void> updateX(int x) async {
    await doc.merge({'x': x});
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

@freezed
class ThingModelProperties with _$ThingModelProperties {
  const factory ThingModelProperties({
    required PropertyGroup group,
    required Property<String, void> name,
    required Property<String, void> identifier,
    required Property<int, PixelOptions> x,
  }) = _ThingModelProperties;
}

@Riverpod(dependencies: [GroupDisabled])
PropertyGroup thingGroup(ThingGroupRef ref) {
  final disabled = ref.watch(groupDisabledProvider);
  return PropertyGroup(
    isDisabled: disabled,
  );
}

@Riverpod(dependencies: [thingModel, thingGroup])
ThingModelProperties thingModelProperties(ThingModelPropertiesRef ref) {
  return ThingModelProperties(
    group: ref.watch(thingGroupProvider),
    name: Property(
      label: 'name',
      value: ref.watch(thingModelProvider.select((value) => value.name)),
      update: (value) => ref.read(thingModelProvider).updateName(value),
      validate: compoundValidator([
        stringNotEmpty,
        stringNotEqual('foo'),
      ]),
    ),
    identifier: Property(
      label: 'identifier',
      value: ref.watch(thingModelProvider.select((value) => value.identifier)),
      update: (value) => ref.read(thingModelProvider).updateIdentifier(value),
      validate: compoundValidator([
        stringNotEmpty,
        stringNotEqual('foo'),
      ]),
    ),
    x: Property(
      label: 'x',
      value: ref.watch(thingModelProvider.select((value) => value.x)),
      update: (value) => ref.read(thingModelProvider).updateX(value),
      validate: (value) {
        return PropertyValidationResult(value: value);
      },
      options: const PixelOptions(),
    ),
  );
}
