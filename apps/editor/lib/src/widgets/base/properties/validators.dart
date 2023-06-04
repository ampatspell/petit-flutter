part of 'properties.dart';

final stringTextBoxPresentation = PropertyPresentation<String, String>(
  type: PropertyPresentationType.textBox,
  toEditorValue: (value) => value,
  toModelValue: (value) => ValidationResult(
    value: value.trim(),
  ),
);

final integerTextBoxPresentation = PropertyPresentation<int, String>(
  type: PropertyPresentationType.textBox,
  toEditorValue: (value) => value.toString(),
  toModelValue: (value) {
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return const ValidationResult(error: 'Must be number');
    }
    return ValidationResult(value: parsed);
  },
);
