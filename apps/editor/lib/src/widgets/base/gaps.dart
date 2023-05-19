import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';

List<Widget> withGapsBetween({required List<Widget> children, required Gap gap}) {
  final widgets = <Widget>[];
  children.asMap().entries.forEach((element) {
    widgets.add(element.value);
    if (element.key < children.length - 1) {
      widgets.add(gap);
    }
  });
  return widgets;
}
