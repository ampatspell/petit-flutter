part of 'loaded_scope.dart';

class ProviderScopeOverridesScaffold extends StatelessWidget {
  final String? title;
  final Widget child;

  const ProviderScopeOverridesScaffold({
    super.key,
    required this.title,
    required this.child,
  });

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
