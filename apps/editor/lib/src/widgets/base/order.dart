import 'package:fluent_ui/fluent_ui.dart';

enum OrderDirection {
  asc(FluentIcons.sort_up),
  desc(FluentIcons.sort_down);

  const OrderDirection(this.icon);

  final IconData icon;

  OrderDirection get next {
    if (this == asc) {
      return desc;
    }
    return asc;
  }

  bool get isDescending {
    return this == desc;
  }
}

CommandBarButton buildOrderCommandBarButton(OrderDirection order, VoidCallback onPressed) {
  return CommandBarButton(
    icon: Icon(order.icon),
    onPressed: onPressed,
  );
}
