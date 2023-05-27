import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/doc.dart';
import '../../models/workspace.dart';
import '../../providers/base.dart';
import '../base/async_values_loader.dart';
import '../base/segmented.dart';
import '../base/text_style.dart';

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

final intToStringConverter = PropertyAccessorConverter<int, String>(
  toEdit: (value) => value.toString(),
  toValue: (edit) {
    final parsed = int.tryParse(edit);
    if (parsed == null) {
      return const PropertyValidationResult(error: 'Must be integer');
    }
    return PropertyValidationResult(value: parsed);
  },
);

final stringToStringConverter = PropertyAccessorConverter<String, String>(
  toEdit: (value) => value.trim().toString(),
  toValue: (edit) => PropertyValidationResult(value: edit.trim().toString()),
);

final intToIntConverter = PropertyAccessorConverter<int, int>(
  toEdit: (value) => value,
  toValue: (edit) => PropertyValidationResult(value: edit),
);

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
class PropertyGroup with _$PropertyGroup {
  const factory PropertyGroup({
    @Default(false) bool isDisabled,
  }) = _PropertyGroup;
}

@freezed
class PropertyValidationResult<Value> with _$PropertyValidationResult<Value> {
  const factory PropertyValidationResult({
    String? error,
    Value? value,
  }) = _PropertyValidationResult<Value>;
}

typedef PropertyValidator<Value> = PropertyValidationResult<Value> Function(Value value);
typedef PropertyUpdate<Value> = void Function(Value value);
typedef PropertyValueToEdit<Edit, Value> = Edit Function(Value value);
typedef PropertyEditToValue<Edit, Value> = PropertyValidationResult<Value> Function(Edit edit);

@freezed
class PropertyAccessorConverter<Value, Edit> with _$PropertyAccessorConverter<Value, Edit> {
  const factory PropertyAccessorConverter({
    required PropertyValueToEdit<Edit, Value> toEdit,
    required PropertyEditToValue<Edit, Value> toValue,
  }) = _PropertyAccessorConverter<Value, Edit>;
}

@freezed
class Property<Value, Options> with _$Property<Value, Options> {
  const factory Property({
    String? label,
    required Value value,
    required PropertyValidator<Value> validate,
    required PropertyUpdate<Value> update,
    @Default(false) bool isDisabled,
    Options? options,
  }) = _Property<Value, Options>;
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

PropertyValidationResult<int> stringToInt(String edit) {
  final parsed = int.tryParse(edit);
  if (parsed == null) {
    return const PropertyValidationResult(error: 'Must be integer');
  }
  return PropertyValidationResult(value: parsed);
}

PropertyValidationResult<String> stringNotEmpty(String value) {
  if (value.isEmpty) {
    return const PropertyValidationResult(error: 'Must not be empty');
  }
  return PropertyValidationResult(value: value);
}

PropertyValidator<String> stringNotEqual(String string) {
  return (value) {
    if (value == string) {
      return PropertyValidationResult(error: 'Must not be equal to $string');
    }
    return PropertyValidationResult(value: value);
  };
}

PropertyValidator<Value> compoundValidator<Value>(
  List<PropertyValidator<Value>> validators,
) {
  return (value) {
    var result = PropertyValidationResult<Value>(error: 'No validators');
    for (final validator in validators) {
      result = validator(value);
      if (result.error != null) {
        return result;
      }
    }
    return result;
  };
}

class PropertyAccessor<Properties, Value, Edit, Options> {
  const PropertyAccessor({
    required this.properties,
    required this.property,
    required this.group,
    required this.converter,
  });

  static PropertyAccessor<Properties, String, String, Options> string<Properties, Options>({
    required AutoDisposeProvider<Properties> properties,
    required Property<String, Options> Function(Properties properties) property,
    required PropertyGroup Function(Properties properties) group,
  }) {
    return PropertyAccessor(
      properties: properties,
      property: property,
      group: group,
      converter: stringToStringConverter,
    );
  }

  static PropertyAccessor<Properties, int, String, Options> integerToString<Properties, Options>({
    required AutoDisposeProvider<Properties> properties,
    required Property<int, Options> Function(Properties properties) property,
    required PropertyGroup Function(Properties properties) group,
  }) {
    return PropertyAccessor(
      properties: properties,
      property: property,
      group: group,
      converter: intToStringConverter,
    );
  }

  static PropertyAccessor<Properties, int, int, Options> integer<Properties, Options>({
    required AutoDisposeProvider<Properties> properties,
    required Property<int, Options> Function(Properties properties) property,
    required PropertyGroup Function(Properties properties) group,
  }) {
    return PropertyAccessor(
      properties: properties,
      property: property,
      group: group,
      converter: intToIntConverter,
    );
  }

  final AutoDisposeProvider<Properties> properties;
  final Property<Value, Options> Function(Properties properties) property;
  final PropertyGroup Function(Properties properties) group;
  final PropertyAccessorConverter<Value, Edit> converter;

  //

  ProviderListenable<Property<Value, Options>> get selectProperty {
    return properties.select(property);
  }

  ProviderListenable<PropertyGroup> get selectGroup {
    return properties.select(group);
  }

  ProviderListenable<Value> get selectValue {
    return properties.select((value) => property(value).value);
  }

  ProviderListenable<Edit> get selectEdit {
    return properties.select((prop) => toEdit(property(prop).value));
  }

  ProviderListenable<String?> get selectLabel {
    return properties.select((value) => property(value).label);
  }

  ProviderListenable<bool> get selectPropertyDisabled {
    return properties.select((value) => property(value).isDisabled);
  }

  ProviderListenable<Options> get selectOptions {
    return properties.select((value) => property(value).options!);
  }

  ProviderListenable<bool> get selectGroupDisabled {
    return properties.select((value) => group(value).isDisabled);
  }

  PropertyValidationResult<Value> validateValue(WidgetRef ref, Value value) {
    return ref.read(selectProperty).validate(value);
  }

  PropertyValidationResult<Value> validateEdit(WidgetRef ref, Edit edit) {
    final result = converter.toValue(edit);
    if (result.error != null) {
      return result;
    }
    return validateValue(ref, result.value as Value);
  }

  void update(WidgetRef ref, Value value) {
    ref.read(selectProperty).update(value);
  }

  Value readValue(WidgetRef ref) {
    return ref.read(selectValue);
  }

  Edit toEdit(Value value) {
    return converter.toEdit(value);
  }

  Edit readEditValue(WidgetRef ref) {
    final value = readValue(ref);
    return toEdit(value);
  }

  String? readCurrentError(WidgetRef ref) {
    final edit = readEditValue(ref);
    return validateEdit(ref, edit).error;
  }

  String? watchLabel(WidgetRef ref) {
    return ref.watch(selectLabel);
  }

  bool watchDisabled(WidgetRef ref) {
    return ref.watch(selectGroupDisabled) || ref.watch(selectPropertyDisabled);
  }

  Edit watchEdit(WidgetRef ref) {
    return ref.watch(selectEdit);
  }

  Options watchOptions(WidgetRef ref) {
    return ref.watch(selectOptions);
  }
}

class PropertyPixelSegmented<Properties, Value> extends ConsumerWidget {
  const PropertyPixelSegmented({
    super.key,
    required this.accessor,
  });

  final PropertyAccessor<Properties, Value, int, PixelOptions> accessor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PropertyLabel(
      accessor: accessor,
      child: Segmented<int>(
        disabled: accessor.watchDisabled(ref),
        selected: accessor.watchEdit(ref),
        segments: accessor.watchOptions(ref).values.map((value) {
          return Segment(label: '${value}x', value: value);
        }).toList(growable: false),
        onSelect: (edit) {
          final result = accessor.validateEdit(ref, edit);
          if (result.error == null) {
            accessor.update(ref, result.value as Value);
          }
        },
      ),
    );
  }
}

class PropertyTextBox<Properties, Value> extends HookConsumerWidget {
  const PropertyTextBox({
    super.key,
    required this.accessor,
  });

  final PropertyAccessor<Properties, Value, String, void> accessor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = useState<String?>(accessor.readCurrentError(ref));

    final controller = useTextEditingController(
      text: accessor.readEditValue(ref),
    );

    ref.listen(accessor.selectValue, (previous, next) {
      if (controller.text != next) {
        controller.text = accessor.toEdit(next);
        error.value = accessor.readCurrentError(ref);
      }
    });

    return PropertyLabel(
      accessor: accessor,
      child: PropertyError<String>(
        error: error.value,
        child: TextBox(
          controller: controller,
          placeholder: '',
          enabled: !accessor.watchDisabled(ref),
          onChanged: (value) {
            final result = accessor.validateEdit(ref, value);
            error.value = result.error;
          },
          onSubmitted: (value) {
            final result = accessor.validateEdit(ref, value);
            if (result.error == null) {
              accessor.update(ref, result.value as Value);
            } else {
              controller.text = accessor.readEditValue(ref);
              error.value = accessor.readCurrentError(ref);
            }
          },
        ),
      ),
    );
  }
}

class PropertyError<T> extends StatelessWidget {
  const PropertyError({
    super.key,
    required this.error,
    required this.child,
  });

  final String? error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (error != null) ...[
          const Gap(3),
          DefaultFluentTextStyle(
            resolve: (typography) {
              final brightness = FluentTheme.of(context).brightness;
              return typography.caption!.copyWith(color: Colors.red.defaultBrushFor(brightness));
            },
            child: Text(error!),
          ),
        ]
      ],
    );
  }
}

class PropertyLabel extends ConsumerWidget {
  const PropertyLabel({
    super.key,
    required this.accessor,
    required this.child,
  });

  final PropertyAccessor<dynamic, dynamic, dynamic, dynamic> accessor;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = accessor.watchLabel(ref);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (value != null) ...[
          DefaultFluentTextStyle(
            resolve: (typography) => typography.bodyStrong,
            child: Text(value),
          ),
          const Gap(1),
        ],
        child,
      ],
    );
  }
}
