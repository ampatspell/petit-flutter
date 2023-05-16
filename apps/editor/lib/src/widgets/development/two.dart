import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers/base.dart';
import '../base/scope_overrides/scope_overrides.dart';

part 'two.freezed.dart';

part 'two.g.dart';

@freezed
class Thing with _$Thing {
  const factory Thing({
    required String name,
  }) = _Thing;
}

@freezed
class Wrapped with _$Wrapped {
  const factory Wrapped({
    required Thing thing,
    required String role,
  }) = _Wrapped;
}

@Riverpod(dependencies: [])
Thing thingByName(ThingByNameRef ref, {required String name}) {
  print('create thing $name');
  return Thing(
    name: name,
  );
}

@Riverpod(dependencies: [thingByName])
Wrapped wrapByName(
  WrapByNameRef ref, {
  required String name,
  required String role,
}) {
  print('create wrap by name and role $name $role');
  final thing = ref.watch(thingByNameProvider(name: name));
  return Wrapped(
    thing: thing,
    role: role,
  );
}

//

@Riverpod(dependencies: [])
String theName(TheNameRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [])
String theRole(TheRoleRef ref) => throw OverrideProviderException();

@Riverpod(dependencies: [theName])
class Name extends _$Name {
  @override
  String build() {
    return ref.read(theNameProvider);
  }

  void reset() {
    state = 'default';
  }
}

@Riverpod(dependencies: [theRole])
class Role extends _$Role {
  @override
  String build() {
    return ref.read(theRoleProvider);
  }

  void reset() {
    state = 'default';
  }
}

@Riverpod(dependencies: [Name, Role, wrapByName])
Wrapped wrapped(WrappedRef ref) {
  final name = ref.watch(nameProvider);
  final role = ref.watch(roleProvider);
  return ref.watch(wrapByNameProvider(
    name: name,
    role: role,
  ));
}

class DevelopmentTwoScreen extends HookConsumerWidget {
  const DevelopmentTwoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Family dependencies'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScopeOverrides(
            overrides: (context, ref) => [
              overrideProvider(theNameProvider).withValue('one'),
              overrideProvider(theRoleProvider).withValue('admin'),
            ],
            child: const WrappedWidget(),
          ),
          const Gap(20),
          ScopeOverrides(
            overrides: (context, ref) => [
              overrideProvider(theNameProvider).withValue('two'),
              overrideProvider(theRoleProvider).withValue('zeeba'),
            ],
            child: const WrappedWidget(),
          ),
        ],
      ),
    );
  }
}

class WrappedWidget extends ConsumerWidget {
  const WrappedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wrapped = ref.watch(wrappedProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(wrapped.toString()),
        const Gap(10),
        Button(
          child: const Text('Reset name'),
          onPressed: () {
            ref.read(nameProvider.notifier).reset();
          },
        ),
        const Gap(10),
        Button(
          child: const Text('Reset role'),
          onPressed: () {
            ref.read(roleProvider.notifier).reset();
          },
        ),
      ],
    );
  }
}
