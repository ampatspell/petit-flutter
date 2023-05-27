import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/doc.dart';

class AsyncValuesLoader extends ConsumerWidget {
  const AsyncValuesLoader({
    super.key,
    required this.providers,
    required this.child,
  });

  final List<ProviderListenable<AsyncValue<dynamic>>> providers;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final values = providers.map((provider) => ref.watch(provider));

    final errors = values.where((value) => value.hasError);
    if (errors.isNotEmpty) {
      for (final e in errors) {
        if (kDebugMode) {
          print('Error: ${e.error}');
          print(e.stackTrace!);
          print('');
        }
      }
      return Text([
        'Errors',
        '',
        ...errors.map((e) => e.error!.toString()),
      ].join('\n'));
    }

    final loading = values.where((value) => !value.hasValue);
    if (loading.isNotEmpty) {
      if (kDebugMode) {
        for (final e in loading) {
          print('Loading: $e');
        }
      }
      return Text([
        'Loading',
        '',
        ...loading.map((e) => e.toString()),
      ].join('\n'));
    }

    final deleted = values.where((e) {
      final value = e.requireValue;

      bool isDeleted(HasDoc value) {
        return !value.doc.exists && !value.doc.isOptional;
      }

      if (value is HasDoc) {
        return isDeleted(value);
      } else if (value is Iterable<HasDoc>) {
        return value.firstWhereOrNull(isDeleted) != null;
      }

      return false;
    });

    if (deleted.isNotEmpty) {
      if (kDebugMode) {
        for (final e in deleted) {
          print('Deleted: $e');
        }
      }
      return Text([
        'Deleted',
        '',
        ...deleted.map((e) => e.toString()),
      ].join('\n'));
    }

    return child;
  }
}
