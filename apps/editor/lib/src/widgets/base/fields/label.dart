part of 'fields.dart';

class FieldLabel extends ConsumerWidget {
  const FieldLabel({
    super.key,
    required this.label,
    required this.child,
    this.show = true,
  });

  final ProviderListenable<String> label;
  final Widget child;
  final bool show;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (show) ...[
          DefaultFluentTextStyle(
            resolve: (typography) => typography.bodyStrong,
            child: Text(ref.watch(label)),
          ),
          const Gap(1),
        ],
        child,
      ],
    );
  }
}
