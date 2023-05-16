part of 'scope_overrides.dart';

class _ProviderScopeOverridesScaffold extends StatelessWidget {
  const _ProviderScopeOverridesScaffold({
    required this.title,
    required this.child,
  });

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: title != null
          ? PageHeader(
              title: Text(title!),
            )
          : null,
      children: [
        child,
      ],
    );
  }
}
