part of 'scope_overrides.dart';

class ScopeOverrides extends ConsumerWidget {
  const ScopeOverrides({
    super.key,
    this.parent,
    required this.overrides,
    required this.child,
    this.onDeleted,
  });

  final List<OverrideLoader<dynamic>> Function(BuildContext context, WidgetRef ref) overrides;
  final VoidCallback? onDeleted;
  final Widget child;
  final Object? parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final built = overrides(context, ref).map((e) {
      return e._toAsyncValue(ref);
    }).toList(growable: false);

    Widget ensureScaffold(String? title, Widget child) {
      final scaffold = context.findAncestorWidgetOfExactType<ScaffoldPage>();
      if (scaffold == null) {
        child = _ProviderScopeOverridesScaffold(
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

    final errors = built.where((e) => e._value.hasError).toList(growable: false);
    if (errors.isNotEmpty) {
      return ensureScaffold(
        'Something went wrong',
        _ProviderScopeOverridesError(errors: errors),
      );
    }

    final loading = built.where((e) => !e._value.hasValue).toList(growable: false);
    if (loading.isNotEmpty) {
      return ensureScaffold(
        null,
        const _ProviderScopeOverridesLoading(),
      );
    }

    if (built.firstWhereOrNull((e) => e._containsDeletedDocs) != null) {
      if (onDeleted != null) {
        // FIXME: is it ok to do router transitions from Widget.build?
        onDeleted!();
        return const SizedBox.shrink();
      } else {
        return ensureScaffold('Deleted', const SizedBox.shrink());
      }
    }

    final withProviders = built.where((e) {
      return e._provider != null;
    }).toList(growable: false);

    final created = withProviders.map((e) {
      return e._provider!.overrideWithValue(e._value.requireValue);
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
              override._provider!,
              override._value.requireValue,
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
