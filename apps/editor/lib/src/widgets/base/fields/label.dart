part of 'fields.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultFluentTextStyle(
          resolve: (typography) => typography.bodyStrong,
          child: Text(label),
        ),
        const Gap(1),
        child,
      ],
    );
  }
}
