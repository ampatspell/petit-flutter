import 'package:freezed_annotation/freezed_annotation.dart';

part 'properties.freezed.dart';

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
    PropertyValidator<T>? validator,
  }) = _Property<T, E>;

  const Property._();

  static Property<int, String> integerTextBox({
    required int value,
    required void Function(int value) update,
    PropertyValidator<int>? validator,
  }) {
    return Property(
      value: value,
      update: update,
      presentation: integerTextBoxPresentation,
      validator: validator,
    );
  }

  static Property<String, String> stringTextBox({
    required String value,
    required void Function(String value) update,
    PropertyValidator<String>? validator,
  }) {
    return Property(
      value: value,
      update: update,
      presentation: stringTextBoxPresentation,
      validator: validator,
    );
  }

  PropertyValidationResult<T> validateEditorValue(E editor) {
    final result = presentation.toValue(editor);
    if (result.error != null) {
      return result;
    }
    if (validator != null) {
      return validator!(result.value as T);
    }
    return result;
  }

  PropertyValidationResult<T> updateWithEditorValue(E editor) {
    final result = validateEditorValue(editor);
    if (result.error == null) {
      update(result.value as T);
    }
    return result;
  }
}

//

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

PropertyValidationResult<String> stringNotEmpty(String value) {
  if (value.isEmpty) {
    return const PropertyValidationResult(error: 'Must not be empty');
  }
  return PropertyValidationResult(value: value);
}

PropertyValidationResult<int> positiveInteger(int value) {
  if (value < 0) {
    return const PropertyValidationResult(error: 'Must be positive');
  }
  return PropertyValidationResult(value: value);
}

PropertyValidator<T> validators<T>(List<PropertyValidator<T>> validators) {
  return (T value) {
    for (final validator in validators) {
      final result = validator(value);
      if (result.error != null) {
        return result;
      }
      value = result.value as T;
    }
    return PropertyValidationResult(value: value);
  };
}
