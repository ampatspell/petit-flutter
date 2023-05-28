import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/theme.dart';
import '../../models/doc.dart';
import '../../providers/base.dart';
import '../base/async_values_loader.dart';
import '../base/gaps.dart';
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
    final properties = ref.watch(thingModelPropertiesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${thing.name}'),
        const Gap(10),
        Text('Properties: $properties'),
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
        Property.integerTextBox(value: model.x, update: model.updateX),
        Property.integerTextBox(value: model.y, update: model.updateY),
      ],
    ),
    PropertyGroup(
      label: 'Name',
      properties: [
        Property.stringTextBox(value: model.name, update: model.updateName),
      ],
    ),
    PropertyGroup(
      label: 'Identifier',
      properties: [
        Property.stringTextBox(value: model.identifier, update: model.updateIdentifier),
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

//

enum PresentationType {
  textBox,
}

@freezed
class PropertyValidationResult<T> with _$PropertyValidationResult<T> {
  const factory PropertyValidationResult({
    String? error,
    T? value,
  }) = _PropertyValidationResult<T>;
}

typedef PropertyValidator<T> = PropertyValidationResult<T> Function(T value);

@freezed
class PropertyPresentation<T, E> with _$PropertyPresentation<T, E> {
  const factory PropertyPresentation({
    required PresentationType type,
    required PropertyValidationResult<T> Function(E editor) toValue,
    required E Function(T value) toEditor,
  }) = _PropertyPresentation<T, E>;

  const PropertyPresentation._();

  E convertToEditor(Property<T, E> property) {
    final value = property.value;
    return toEditor(value);
  }

  PropertyValidationResult<T> updateWithEditorValue(Property<T, E> property, E editor) {
    final result = toValue(editor);
    if (result.error == null) {
      property.update(result.value as T);
    }
    return result;
  }
}

@freezed
class PropertyGroup with _$PropertyGroup {
  const factory PropertyGroup({
    String? label,
    required List<Property<dynamic, dynamic>> properties,
  }) = _PropertyGroup;
}

@freezed
class Properties with _$Properties {
  const factory Properties({
    required List<PropertyGroup> groups,
  }) = _Properties;
}

@freezed
class Property<T, E> with _$Property<T, E> {
  const factory Property({
    required T value,
    required void Function(T value) update,
    required PropertyPresentation<T, E> presentation,
  }) = _Property<T, E>;

  const Property._();

  static Property<int, String> integerTextBox({
    required int value,
    required void Function(int value) update,
  }) {
    return Property(
      value: value,
      update: update,
      presentation: integerTextBoxPresentation,
    );
  }

  static Property<String, String> stringTextBox({
    required String value,
    required void Function(String value) update,
  }) {
    return Property(
      value: value,
      update: update,
      presentation: stringTextBoxPresentation,
    );
  }
}

final integerTextBoxPresentation = PropertyPresentation<int, String>(
  type: PresentationType.textBox,
  toEditor: (value) => value.toString(),
  toValue: (editor) {
    final parsed = int.tryParse(editor);
    if (parsed == null) {
      return const PropertyValidationResult(error: 'Must be integer');
    }
    return PropertyValidationResult(value: parsed);
  },
);

final stringTextBoxPresentation = PropertyPresentation<String, String>(
  type: PresentationType.textBox,
  toEditor: (value) => value,
  toValue: (editor) {
    final trimmed = editor.trim();
    return PropertyValidationResult(value: trimmed);
  },
);

//

class PropertiesWidget extends ConsumerWidget {
  const PropertiesWidget({
    super.key,
    required this.properties,
  });

  final AutoDisposeProvider<Properties> properties;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build properties');

    final length = ref.watch(properties.select((value) => value.groups.length));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < length; i++)
          PropertyGroupWidget(
            properties: properties,
            group: (properties) => properties.groups[i],
          ),
      ],
    );
  }
}

class PropertyGroupWidget extends ConsumerWidget {
  const PropertyGroupWidget({super.key, required this.properties, required this.group});

  final ProviderListenable<Properties> properties;
  final PropertyGroup Function(Properties properties) group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = ref.watch(properties.select((value) => group(value).label));
    final length = ref.watch(properties.select((value) => group(value).properties.length));

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Grey.grey100),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            DefaultFluentTextStyle(
              resolve: (typography) => typography.caption,
              child: Text(label),
            ),
            const Gap(3),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...withGapsBetween(
                children: [
                  for (var i = 0; i < length; i++)
                    Expanded(
                      child: PropertyWidget(
                        helper: PropertyWidgetHelper<dynamic, dynamic>(
                          properties: properties,
                          property: (properties) => group(properties).properties[i],
                        ),
                      ),
                    )
                ],
                gap: const Gap(10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PropertyWidgetHelper<T, E> {
  const PropertyWidgetHelper({
    required this.properties,
    required this.property,
  });

  final ProviderListenable<Properties> properties;
  final Property<T, E> Function(Properties properties) property;

  ProviderListenable<R> select<R>(R Function(Property<T, E> property) cb) {
    return properties.select((value) {
      return cb(property(value));
    });
  }

  ProviderListenable<E> selectEditorValue() {
    return select((property) {
      return property.presentation.convertToEditor(property);
    });
  }

  ProviderListenable<T> selectValue() {
    return select((property) {
      return property.value;
    });
  }

  T readValue(WidgetRef ref) {
    return ref.read(selectValue());
  }

  E readEditorValue(WidgetRef ref) {
    return ref.read(selectEditorValue());
  }

  PropertyValidationResult<dynamic> updateWithEditorValue(WidgetRef ref, E value) {
    return ref.read(select((property) {
      return property.presentation.updateWithEditorValue(property, value);
    }));
  }

  PropertyValidationResult<T> validateEditorValue(WidgetRef ref, E value) {
    return ref.read(select((property) {
      return property.presentation.toValue(value);
    }));
  }

  PropertyWidgetHelper<T, N> cast<N>() {
    return PropertyWidgetHelper(
      properties: properties,
      property: (properties) => property(properties) as Property<T, N>,
    );
  }
}

class PropertyWidget extends ConsumerWidget {
  const PropertyWidget({
    super.key,
    required this.helper,
  });

  final PropertyWidgetHelper<dynamic, dynamic> helper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build property');
    final type = ref.watch(helper.select((property) => property.presentation.type));
    switch (type) {
      case PresentationType.textBox:
        return TextBoxPropertyWidget(helper: helper.cast<String>());
    }
  }
}

class TextBoxPropertyWidget extends HookConsumerWidget {
  const TextBoxPropertyWidget({
    super.key,
    required this.helper,
  });

  final PropertyWidgetHelper<dynamic, String> helper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: helper.readEditorValue(ref));

    ref.listen(helper.selectEditorValue(), (previous, next) {
      if (controller.text != next) {
        controller.text = next;
      }
    });

    late ValueNotifier<String?> error;

    return Focus(
      onFocusChange: (value) {
        if (!value) {
          controller.text = helper.readEditorValue(ref);
          error.value = helper.validateEditorValue(ref, controller.text).error;
        }
      },
      child: PropertyErrorWidget(
        register: (next) => error = next,
        child: TextBox(
          placeholder: '',
          controller: controller,
          onChanged: (value) {
            final result = helper.validateEditorValue(ref, value);
            error.value = result.error;
          },
          onSubmitted: (value) {
            final result = helper.updateWithEditorValue(ref, value);
            error.value = result.error;
          },
        ),
      ),
    );
  }
}

class PropertyErrorWidget extends HookWidget {
  const PropertyErrorWidget({
    super.key,
    required this.register,
    required this.child,
  });

  final Widget child;
  final void Function(ValueNotifier<String?> error) register;

  @override
  Widget build(BuildContext context) {
    print('build error');

    final error = useState<String?>(null);
    register(error);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (error.value != null) ...[
          const Gap(3),
          DefaultFluentTextStyle(
            resolve: (typography) {
              final brightness = FluentTheme.of(context).brightness;
              return typography.caption!.copyWith(color: Colors.red.defaultBrushFor(brightness));
            },
            child: Text(error.value!),
          ),
        ],
      ],
    );
  }
}
