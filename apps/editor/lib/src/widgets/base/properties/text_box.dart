part of 'properties.dart';

class PropertyTextBox extends StatelessWidget {
  const PropertyTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PropertyState>() as PropertyTextBoxState;
    return PropertyError(
      child: Focus(
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
    );
  }
}
