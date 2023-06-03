import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/theme.dart';
import '../../models/properties.dart';
import '../../providers/base.dart';
import 'gaps.dart';
import 'text_style.dart';

part 'properties.g.dart';

part 'properties.freezed.dart';

@Riverpod(dependencies: [])
Properties? widgetProperties(WidgetPropertiesRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
PropertyGroup widgetPropertyGroup(WidgetPropertyGroupRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
Property<dynamic, dynamic> widgetProperty(WidgetPropertyRef ref) => throw OverrideProviderException();

@freezed
class WidgetPropertyStateData with _$WidgetPropertyStateData {
  const factory WidgetPropertyStateData({
    required Property<dynamic, dynamic> property,
    required PropertyValidationResult<dynamic> validation,
    required dynamic editor,
  }) = _WidgetPropertyStateData;
}

// @Riverpod(dependencies: [widgetProperty])
// class WidgetPropertyState extends _$WidgetPropertyState {
//   @override
//   WidgetPropertyStateData build() {
//     ref.listen(widgetPropertyProvider, (previous, next) {
//       final editor = next.currentEditorValue;
//       state = state.copyWith(
//         property: next,
//         editor: editor,
//         validation: next.validateEditorValue(editor),
//       );
//     }, fireImmediately: true);
//   }
//
//   void updateEditorValue(dynamic editor) {
//     state = state.copyWith(
//       editor: editor,
//       validation: state.property.validateEditorValue(editor),
//     );
//   }
// }

class PropertiesWidget extends ConsumerWidget {
  const PropertiesWidget({
    super.key,
    required this.provider,
  });

  final AutoDisposeProvider<Properties?> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final properties = ref.watch(provider);
    return ProviderScope(
      overrides: [
        widgetPropertiesProvider.overrideWithValue(properties),
      ],
      child: const PropertyGroupsWidget(),
    );
  }
}

class PropertyGroupsWidget extends ConsumerWidget {
  const PropertyGroupsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(widgetPropertiesProvider.select((value) => value?.groups ?? []));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...groups.map((group) {
          return ProviderScope(
            overrides: [
              widgetPropertyGroupProvider.overrideWithValue(group),
            ],
            child: const PropertyGroupWidget(),
          );
        }),
      ],
    );
  }
}

class PropertyWidgetHelper<T, E> {
  const PropertyWidgetHelper();

  ProviderListenable<R> select<R>(R Function(Property<T, E> property) cb) {
    return widgetPropertyProvider.select((value) => cb(value as Property<T, E>));
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

  PropertyValidationResult<T> updateWithEditorValue(WidgetRef ref, E value) {
    return ref.read(select((property) {
      return property.updateWithEditorValue(value);
    }));
  }

  PropertyValidationResult<T> validateEditorValue(WidgetRef ref, E value) {
    return ref.read(select((property) {
      return property.validateEditorValue(value);
    }));
  }

  PropertyWidgetHelper<T, N> cast<N>() {
    return PropertyWidgetHelper<T, N>();
  }
}

class PropertyGroupWidget extends ConsumerWidget {
  const PropertyGroupWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = ref.watch(widgetPropertyGroupProvider.select((value) => value.label));

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Grey.grey245),
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
          const PropertyGroupPropertiesWidget(),
        ],
      ),
    );
  }
}

class PropertyGroupPropertiesWidget extends ConsumerWidget {
  const PropertyGroupPropertiesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final properties = ref.watch(widgetPropertyGroupProvider.select((value) => value.properties));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...withGapsBetween(
          children: [
            ...properties.map((property) {
              return ProviderScope(
                overrides: [
                  widgetPropertyProvider.overrideWithValue(property),
                ],
                child: const Expanded(
                  child: PropertyWidget(),
                ),
              );
            }),
          ],
          gap: const Gap(10),
        ),
      ],
    );
  }
}

class PropertyWidget extends ConsumerWidget {
  const PropertyWidget({super.key});

  final PropertyWidgetHelper<dynamic, dynamic> helper = const PropertyWidgetHelper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(helper.select((property) => property.presentation.type));
    switch (type) {
      case PresentationType.textBox:
        return const TextBoxPropertyWidget();
    }
  }
}

class TextBoxPropertyWidget extends HookConsumerWidget {
  const TextBoxPropertyWidget({super.key});

  final PropertyWidgetHelper<dynamic, String> helper = const PropertyWidgetHelper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: helper.readEditorValue(ref));
    late ValueNotifier<String?> error;

    void update() {
      final editor = helper.readEditorValue(ref);
      controller.text = editor;
      error.value = helper.validateEditorValue(ref, editor).error;
    }

    // ref.listen(widgetPropertyStateProvider, (previous, next) {
    //   controller.text = next.editor as String;
    // });

    ref.listen(helper.selectEditorValue(), (previous, next) {
      if (controller.text != next) {
        update();
      }
    });

    return Focus(
      onFocusChange: (value) {
        if (!value) {
          update();
        }
      },
      child: PropertyErrorWidget(
        register: (next) {
          error = next;
          error.value = helper.validateEditorValue(ref, controller.text).error;
        },
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
          textInputAction: TextInputAction.done,
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
