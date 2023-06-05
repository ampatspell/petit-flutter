part of 'properties.dart';

abstract class PropertyState with Mountable {
  String? get error;
}

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
    _cancelReaction = reaction(
      (reaction) => property.editorValue,
      onEditorValueChanged,
      name: '_PropertyState.editorValue.reaction',
    );
  }

  @override
  void onUnmounted() {
    super.onUnmounted();
    _cancelReaction!();
    _cancelReaction = null;
  }

  @observable
  String? error;

  @action
  void validateEditorValue(E value) {
    error = property.validateEditorValue(value);
  }
}
