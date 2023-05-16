part of 'scope_overrides.dart';

class ProviderScopeOverridesError extends StatelessWidget {
  const ProviderScopeOverridesError({
    super.key,
    required this.errors,
  });

  final List<ScopeLoader<dynamic>> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var error in errors) ...[
          Text([
            error.value.error.toString(),
            error.value.stackTrace.toString(),
          ].join('\n\n')),
          const Gap(20),
        ],
      ],
    );
  }
}
