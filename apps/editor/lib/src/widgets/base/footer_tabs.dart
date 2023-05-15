import 'package:fluent_ui/fluent_ui.dart';

import '../../app/theme.dart';

class FooterTabs<T> extends StatelessWidget {
  const FooterTabs({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final List<FooterTab<T>> items;
  final T? selected;
  final void Function(T? value)? onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withAlpha(20))),
      ),
      child: Row(
        children: items.map((e) {
          return _FooterTab<T>(
            item: e,
            isSelected: e.value == selected,
            onSelect: onSelect,
          );
        }).toList(growable: false),
      ),
    );
  }
}

class FooterTab<T> {
  const FooterTab({
    required this.icon,
    required this.value,
  });

  final Icon icon;
  final T value;
}

class _FooterTab<T> extends StatelessWidget {
  const _FooterTab({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onSelect,
  });

  final FooterTab<T> item;
  final bool isSelected;
  final void Function(T? value)? onSelect;

  @override
  Widget build(BuildContext context) {
    VoidCallback? onPressed;
    if (onSelect != null) {
      onPressed = () {
        onSelect!(item.value);
      };
    }

    return Button(
      style: ButtonStyle(
        border: ButtonState.all(BorderSide.none),
        padding: ButtonState.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
        shape: ButtonState.all(LinearBorder.none),
        backgroundColor: ButtonState.resolveWith((states) {
          if (isSelected) {
            return Grey.grey245;
          }
          return Colors.white;
        }),
      ),
      child: item.icon,
      onPressed: onPressed,
    );
  }
}
