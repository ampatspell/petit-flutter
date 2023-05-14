part of 'loaded_scope.dart';

class LoadedScope extends ConsumerWidget {
  const LoadedScope({
    super.key,
    this.parent,
    required this.loaders,
    required this.child,
  });

  final List<ScopeLoader<dynamic>> Function(BuildContext context, WidgetRef ref) loaders;
  final Widget child;
  final Object? parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final built = loaders(context, ref);

    Widget ensureScaffold(String? title, Widget child) {
      final scaffold = context.findAncestorWidgetOfExactType<ScaffoldPage>();
      if (scaffold == null) {
        child = ProviderScopeOverridesScaffold(
          title: title,
          child: child,
        );
      } else {
        child = Padding(
          padding: const EdgeInsets.all(10.0),
          child: child,
        );
      }
      return child;
    }

    final errors = built.where((element) => element.value.hasError).toList(growable: false);
    if (errors.isNotEmpty) {
      return ensureScaffold('Something went wrong', ProviderScopeOverridesError(errors: errors));
    }

    final loading = built.where((element) => !element.value.hasValue).toList(growable: false);
    if (loading.isNotEmpty) {
      return ensureScaffold(null, const ProviderScopeOverridesLoading());
    }

    final withProviders = built.where((e) {
      return e.provider != null;
    }).toList(growable: false);

    final created = withProviders.map((e) {
      return e.provider!.overrideWithValue(e.value.requireValue);
    }).toList(growable: false);

    if (created.isEmpty) {
      return child;
    }

    var scopeChild = child;
    if (withProviders.isNotEmpty) {
      scopeChild = Consumer(
        builder: (context, ref, child) {
          final container = ProviderScope.containerOf(context);
          final logging = ref.read(loggingObserverProvider);
          for (final override in withProviders) {
            logging.didOverrideProvider(
              override.provider!,
              override.value.requireValue,
              container,
              parent?.runtimeType.toString(),
            );
          }
          return child!;
        },
        child: scopeChild,
      );
    }

    return ProviderScope(
      overrides: created,
      child: scopeChild,
    );
  }
}
