import 'package:fluent_ui/fluent_ui.dart';

class DefaultFluentTextStyle extends StatelessWidget {
  const DefaultFluentTextStyle({
    super.key,
    required this.resolve,
    required this.child,
  });

  final TextStyle? Function(Typography typography) resolve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = resolve(FluentTheme.of(context).typography);
    if (style != null) {
      return DefaultTextStyle(
        style: style,
        child: child,
      );
    }
    return child;
  }
}
