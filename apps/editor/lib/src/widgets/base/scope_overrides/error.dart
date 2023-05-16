part of 'scope_overrides.dart';

class _ProviderScopeOverridesError extends StatelessWidget {
  const _ProviderScopeOverridesError({
    required this.errors,
  });

  final List<_AsyncValueLoader<dynamic>> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var error in errors) ...[
          Text([
            error._value.error.toString(),
            error._value.stackTrace.toString(),
          ].join('\n\n')),
          const Gap(20),
        ],
      ],
    );
  }
}
