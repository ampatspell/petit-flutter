import 'package:fluent_ui/fluent_ui.dart';

import '../../app/theme.dart';

enum IconTabsPlacement {
  top,
  bottom,
}

class IconTabs<T> extends StatelessWidget {
  const IconTabs({
    super.key,
    required this.placement,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final IconTabsPlacement placement;
  final List<IconTab<T>> items;
  final T? selected;
  final void Function(T? value)? onSelect;

  Border? get border {
    final side = BorderSide(color: Colors.black.withAlpha(20));
    switch (placement) {
      case IconTabsPlacement.bottom:
        return Border(top: side);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: border,
      ),
      child: Row(
        children: items.map((e) {
          return _IconTab<T>(
            item: e,
            isSelected: e.value == selected,
            onSelect: onSelect,
          );
        }).toList(growable: false),
      ),
    );
  }
}

class IconTab<T> {
  const IconTab({
    required this.icon,
    required this.value,
  });

  final Icon icon;
  final T value;
}

class _IconTab<T> extends StatelessWidget {
  const _IconTab({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onSelect,
  });

  final IconTab<T> item;
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
