import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers/base.dart';
import '../base/loaded_scope/loaded_scope.dart';

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
Wrapped wrapByName(WrapByNameRef ref, {required String name}) {
  print('create wrap by name: $name');
  final thing = ref.watch(thingByNameProvider(name: name));
  return Wrapped(
    thing: thing,
  );
}

//

@Riverpod(dependencies: [])
String theName(TheNameRef ref) => throw OverrideProviderException();

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

@Riverpod(dependencies: [Name, wrapByName])
Wrapped wrapped(WrappedRef ref) {
  final name = ref.watch(nameProvider);
  return ref.watch(wrapByNameProvider(name: name));
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
          LoadedScope(
            loaders: (context, ref) => [
              overrideProvider(theNameProvider).withValue('one'),
            ],
            child: const WrappedWidget(),
          ),
          const Gap(20),
          LoadedScope(
            loaders: (context, ref) => [
              overrideProvider(theNameProvider).withValue('two'),
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
          child: const Text('Reset'),
          onPressed: () {
            ref.read(nameProvider.notifier).reset();
          },
        ),
      ],
    );
  }
}
