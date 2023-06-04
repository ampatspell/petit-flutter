import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:zug/zug.dart';

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

class DevelopmentTwoScreenContent extends StatelessWidget {
  const DevelopmentTwoScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Description(),
        const Gap(10),
        _Form(),
      ],
    );
  }
}

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final main = context.watch<Main>();
    return Provider<Property<dynamic, dynamic>>(
      create: (context) => main.thing.name,
      child: const PropertyTextBox(),
    );
  }
}

class PropertyTextBoxState = _PropertyTextBoxState with _$PropertyTextBoxState;

@StoreConfig(hasToString: false)
abstract class _PropertyTextBoxState extends _PropertyState<String> with Store {
  _PropertyTextBoxState({required super.property});

  TextEditingController? _controller;

  TextEditingController get controller => _controller!;

  @override
  void onMounted() {
    super.onMounted();
    _controller = TextEditingController(text: property.editorValue);
  }

  @override
  void onUnmounted() {
    super.onUnmounted();
    _controller!.dispose();
    _controller = null;
  }

  @override
  void onEditorValueChanged(String value) {
    if (controller.text != value) {
      controller.text = value;
    }
  }

  @observable
  String? error;

  void validate(String value) {
    error = property.validateEditorValue(value);
  }

  @action
  void onChanged(String value) {
    validate(value);
  }

  void reset() {
    controller.text = property.editorValue;
    error = null;
  }

  @action
  Future<void> onSubmitted(String value) async {
    validate(value);
    if (error != null) {
      reset();
    } else {
      await property.setEditorValue(value);
    }
  }

  @action
  void onFocusOut() {
    reset();
  }
}

@StoreConfig(hasToString: false)
abstract class _PropertyState<E> with Store, Mountable {
  _PropertyState({
    required Property<dynamic, dynamic> property,
  }) : property = property as Property<dynamic, E>;

  final Property<dynamic, E> property;
  ReactionDisposer? _cancelReaction;

  void onEditorValueChanged(E value);

  @override
  void onMounted() {
    super.onMounted();
    print('onMounted');
    _cancelReaction = reaction((reaction) => property.editorValue, onEditorValueChanged);
  }

  @override
  void onUnmounted() {
    super.onUnmounted();
    print('onUnmounted');
    _cancelReaction!();
    _cancelReaction = null;
  }
}

class PropertyTextBox extends StatelessWidget {
  const PropertyTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MountingProvider(
      create: (context) => PropertyTextBoxState(property: context.read()),
      child: Observer(builder: (context) {
        final state = context.watch<PropertyTextBoxState>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Focus(
              onFocusChange: (focus) {
                if (!focus) {
                  state.onFocusOut();
                }
              },
              child: TextBox(
                controller: state.controller,
                placeholder: '',
                onChanged: state.onChanged,
                onSubmitted: state.onSubmitted,
              ),
            ),
            if (state.error != null) ...[
              const Gap(5),
              Text(state.error!),
            ],
          ],
        );
      }),
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

@StoreConfig(hasToString: false)
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

@StoreConfig(hasToString: false)
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

class PropertyGroups {
  const PropertyGroups(this.all);

  final Iterable<PropertyGroup> all;
}

class PropertyGroup {
  const PropertyGroup({
    required this.name,
    required this.properties,
  });

  final String name;
  final Iterable<Property<dynamic, dynamic>> properties;
}

typedef PropertyValidator<T> = String? Function(T value);

String? stringNotBlankValidator(String value) {
  if (value.trim().isEmpty) {
    return 'Is required';
  }
  return null;
}

String? intIsPositiveValidator(int value) {
  if (value < 0) {
    return 'Must be positive';
  }
  return null;
}

enum PropertyPresentationType {
  textBox,
}

typedef ToEditorValue<T, E> = E Function(T value);
typedef ToModelValue<T, E> = T Function(E value);

class PropertyPresentation<T, E> {
  const PropertyPresentation({
    required this.type,
    required this.toEditorValue,
    required this.toModelValue,
  });

  final PropertyPresentationType type;
  final ToEditorValue<T, E> toEditorValue;
  final ToModelValue<T, E> toModelValue;

  @override
  String toString() {
    return 'PropertyPresentation<$T, $E>{type: ${type.name}}';
  }
}

final stringTextBoxPresentation = PropertyPresentation<String, String>(
  type: PropertyPresentationType.textBox,
  toEditorValue: (value) => value,
  toModelValue: (value) => value,
);

final integerTextBoxPresentation = PropertyPresentation<int, String>(
  type: PropertyPresentationType.textBox,
  toEditorValue: (value) => value.toString(),
  toModelValue: (value) {
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return 0;
    }
    return parsed;
  },
);

typedef PropertyValueGetter = dynamic Function(String key);
typedef PropertyValueSetter<T> = Future<void> Function(String key, T value);

class Property<T, E> {
  Property({
    required this.key,
    required this.initial,
    required this.validator,
    required this.getter,
    required this.setter,
    required this.presentation,
  });

  factory Property.document(
    Document Function() doc, {
    required String key,
    required T initial,
    required PropertyValidator<T> validator,
    required PropertyPresentation<T, E> presentation,
  }) {
    return Property(
      key: key,
      initial: initial,
      validator: validator,
      presentation: presentation,
      getter: (key) => doc()[key],
      setter: (key, value) => doc().merge({key: value}),
    );
  }

  factory Property.documentModel(
    DocumentModel model, {
    required String key,
    required T initial,
    required PropertyValidator<T> validator,
    required PropertyPresentation<T, E> presentation,
  }) {
    return Property.document(
      () => model.doc,
      key: key,
      initial: initial,
      validator: validator,
      presentation: presentation,
    );
  }

  final String key;
  final T initial;
  final PropertyValidator<T> validator;
  final PropertyValueGetter getter;
  final PropertyValueSetter<T> setter;
  final PropertyPresentation<T, E> presentation;

  T get value {
    return getter(key) as T? ?? initial;
  }

  E get editorValue => presentation.toEditorValue(value);

  String? validateEditorValue(E value) {
    return validator(presentation.toModelValue(value));
  }

  Future<void> setValue(T value) async {
    await setter(key, value);
  }

  Future<bool> setEditorValue(E editor) async {
    final value = presentation.toModelValue(editor);
    if (validator(value) != null) {
      return false;
    }
    await setValue(value);
    return true;
  }

  @override
  String toString() {
    return 'Property<$T>{key: $key, value: $value, presentation: $presentation}';
  }
}

// class ThingContent extends ConsumerWidget {
//   const ThingContent({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ThingDescription(),
//         Gap(10),
//         ThingForm(),
//       ],
//     );
//   }
// }
//
// class ThingForm extends ConsumerWidget {
//   const ThingForm({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return PropertiesWidget(
//       provider: thingModelPropertiesProvider,
//     );
//   }
// }
//
// class ThingDescription extends ConsumerWidget {
//   const ThingDescription({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final thing = ref.watch(thingModelProvider);
//     // final properties = ref.watch(thingModelPropertiesProvider);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Name: ${thing.name}'),
//         // const Gap(10),
//         // Text('Properties: $properties'),
//         const Gap(10),
//         FilledButton(
//           child: const Text('Toggle name'),
//           onPressed: () {
//             late final String name;
//             if (thing.name == 'One') {
//               name = 'Two';
//             } else {
//               name = 'One';
//             }
//             ref.read(thingModelProvider).updateName(name);
//           },
//         ),
//         const Gap(10),
//         FilledButton(
//           child: const Text('Clear name'),
//           onPressed: () {
//             ref.read(thingModelProvider).updateName(null);
//           },
//         ),
//         const Gap(10),
//         FilledButton(
//           child: const Text('Toggle group disabled'),
//           onPressed: () {
//             ref.read(groupDisabledProvider.notifier).toggle();
//           },
//         ),
//       ],
//     );
//   }
// }
//
//
// @Riverpod(dependencies: [firebaseServices])
// Stream<ThingModel> thingModelStream(ThingModelStreamRef ref) {
//   final firestore = ref.watch(firebaseServicesProvider.select((value) => value.firestore));
//   return firestore.doc('development/thing').snapshots(includeMetadataChanges: true).map((event) {
//     return ThingModel(doc: Doc.fromSnapshot(event, isOptional: true));
//   });
// }
//
// @Riverpod(dependencies: [thingModelStream])
// ThingModel thingModel(ThingModelRef ref) {
//   return ref.watch(thingModelStreamProvider.select((value) => value.requireValue));
// }
//
// @Riverpod(dependencies: [thingModel])
// Properties thingModelProperties(ThingModelPropertiesRef ref) {
//   final model = ref.watch(thingModelProvider);
//   return Properties(groups: [
//     PropertyGroup(
//       label: 'Position',
//       properties: [
//         Property.integerTextBox(
//           value: model.x,
//           update: model.updateX,
//           validator: positiveInteger,
//         ),
//         Property.integerTextBox(
//           value: model.y,
//           update: model.updateY,
//           validator: positiveInteger,
//         ),
//       ],
//     ),
//     PropertyGroup(
//       label: 'Name',
//       properties: [
//         Property.stringTextBox(
//           value: model.name,
//           update: model.updateName,
//           validator: stringNotEmpty,
//         ),
//       ],
//     ),
//     PropertyGroup(
//       label: 'Identifier',
//       properties: [
//         Property.stringTextBox(
//           value: model.identifier,
//           update: model.updateIdentifier,
//           validator: stringNotEmpty,
//         ),
//       ],
//     ),
//   ]);
// }
//
// @Riverpod(dependencies: [])
// class GroupDisabled extends _$GroupDisabled {
//   @override
//   bool build() {
//     return false;
//   }
//
//   void toggle() {
//     state = !state;
//   }
// }
