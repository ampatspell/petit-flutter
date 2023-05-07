// enum OrderDirection {
//   asc(FluentIcons.sort_up),
//   desc(FluentIcons.sort_down);
//
//   final IconData icon;
//
//   const OrderDirection(this.icon);
//
//   OrderDirection get next {
//     if (this == asc) {
//       return desc;
//     }
//     return asc;
//   }
//
//   bool get isDescending {
//     return this == desc;
//   }
// }
//
// CommandBarButton buildOrderCommandBarButton(ValueNotifier<OrderDirection> order) {
//   return CommandBarButton(
//     icon: Icon(order.value.icon),
//     onPressed: () => order.value = order.value.next,
//   );
// }

// ValueNotifier<OrderDirection> useOrderState() => useState(OrderDirection.asc);
