part of 'properties.dart';

typedef PropertyValidator<T> = String? Function(T value);
typedef ToEditorValue<T, E> = E Function(T value);
typedef ToModelValue<T, E> = ValidationResult<T> Function(E value);
typedef PropertyValueGetter = dynamic Function(String key);
typedef PropertyValueSetter<T> = Future<void> Function(String key, T value);

class PropertyGroups {
  const PropertyGroups(this.all);

  final Iterable<PropertyGroup> all;
}

class PropertyGroup {
  const PropertyGroup({
    this.name,
    required this.properties,
  });

  final String? name;
  final Iterable<Property<dynamic, dynamic>> properties;
}

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

String? noopValidator<T>(T value) {
  return null;
}

String? Function(int value) intIsInRangeValidator(int min, int? max) {
  return (int value) {
    if (max == null) {
      if (value < min) {
        return 'Must be at least $min';
      }
      return null;
    }
    if (value < min || value > max) {
      return 'Must be in range from $min to $max';
    }
    return null;
  };
}

enum PropertyPresentationType {
  textBox,
}

class ValidationResult<T> {
  const ValidationResult({
    this.error,
    this.value,
  });

  final String? error;
  final T? value;
}

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

class Property<T, E> {
  Property({
    required this.key,
    required this.initial,
    required this.validator,
    required this.getter,
    required this.setter,
    required this.presentation,
  });

  factory Property.document({
    required Document Function() doc,
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

  factory Property.documentModel({
    required DocumentModel Function() model,
    required String key,
    required T initial,
    required PropertyValidator<T> validator,
    required PropertyPresentation<T, E> presentation,
  }) {
    return Property.document(
      doc: () => model().doc,
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

  String? validateEditorValue(E editor) {
    final result = presentation.toModelValue(editor);
    if (result.error != null) {
      return result.error;
    }
    final value = result.value as T;
    return validator(value);
  }

  Future<void> setValue(T value) async {
    await setter(key, value);
  }

  Future<bool> setEditorValue(E editor) async {
    final result = presentation.toModelValue(editor);
    if (result.error != null) {
      return false;
    }
    final value = result.value as T;
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
