import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/doc.dart';
import '../../providers/base.dart';
import '../base/async_values_loader.dart';
import '../base/fields/fields.dart';

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
        const Gap(10),
        FieldTextBox(
          provider: thingNameFieldProvider,
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

  String? get identifier => doc['identifier'] as String?;

  Future<void> updateName(String? name) async {
    await doc.merge({'name': name});
  }

  Future<void> updateIdentifier(String? identifier) async {
    await doc.merge({'identifier': identifier});
  }

  Future<void> updateX(int x) async {
    await doc.merge({'x': x});
  }

  Property<String, void> get nameProperty => Property(
        name: 'name',
        value: name,
        update: updateName,
        validate: (property, value) {
          if (value.trim().isNotEmpty) {
            if (value == 'One') {
              return const PropertyValidation(error: "Can't be 'One'");
            }
            return PropertyValidation(value: value.trim());
          }
          return const PropertyValidation(error: 'Name is required');
        },
      );
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

@Riverpod(dependencies: [GroupDisabled])
FieldGroup thingFieldGroup(ThingFieldGroupRef ref) {
  return FieldGroup(
    isDisabled: ref.watch(groupDisabledProvider),
  );
}

@Riverpod(dependencies: [thingModel, thingFieldGroup])
Field<String, void> thingNameField(ThingNameFieldRef ref) {
  return Field(
    group: ref.watch(thingFieldGroupProvider),
    property: ref.watch(thingModelProvider.select((value) => value.nameProperty)),
  );
}
