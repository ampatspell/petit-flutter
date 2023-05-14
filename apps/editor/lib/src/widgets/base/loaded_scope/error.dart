part of 'loaded_scope.dart';

class ProviderScopeOverridesError extends StatelessWidget {
  final List<ScopeLoader<dynamic>> errors;

  const ProviderScopeOverridesError({
    super.key,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var error in errors) ...[
          Text([
            error.value.error.toString(),
            error.value.stackTrace.toString(),
          ].join('\n')),
          const Gap(20),
        ],
      ],
    );
  }
}
