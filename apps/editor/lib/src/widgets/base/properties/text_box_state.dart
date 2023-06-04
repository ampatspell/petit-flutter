part of 'properties.dart';

class PropertyTextBoxState = _PropertyTextBoxState
    with _$PropertyTextBoxState, _$_PropertyTextBoxState
    implements PropertyState;

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

  @action
  void onChanged(String value) {
    validateEditorValue(value);
  }

  @action
  void reset() {
    error = null;
    controller.text = property.editorValue;
  }

  @action
  Future<void> onSubmitted(String value) async {
    validateEditorValue(value);
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
