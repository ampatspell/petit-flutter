import 'package:fluent_ui/fluent_ui.dart';

class ComboBoxCommandBarItem<T> extends CommandBarItem {
  ComboBoxCommandBarItem({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.placeholder,
  });

  final T? value;
  final List<ComboBoxItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context, CommandBarItemDisplayMode displayMode) {
    return ComboBox<T>(
      value: value,
      items: items,
      placeholder: placeholder,
      onChanged: onChanged,
    );
  }
}
