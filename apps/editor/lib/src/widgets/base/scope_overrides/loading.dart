part of 'scope_overrides.dart';

class _ProviderScopeOverridesLoading extends StatelessWidget {
  const _ProviderScopeOverridesLoading({required this.loading});

  final List<_AsyncValueLoader<dynamic>> loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Loading…'),
        const Gap(10),
        ...loading.map((e) => Text(e.toString())),
      ],
    );
  }
}
