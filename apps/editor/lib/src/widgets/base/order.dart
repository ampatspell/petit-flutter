import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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

CommandBarButton buildOrderCommandBarButton({
  required OrderDirection Function() order,
  required VoidCallback onPressed,
}) {
  return CommandBarButton(
    icon: Observer(
      builder: (context) {
        final value = order();
        return Icon(value.icon);
      },
    ),
    onPressed: onPressed,
  );
}
