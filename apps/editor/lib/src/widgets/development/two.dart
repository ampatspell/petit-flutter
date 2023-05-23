import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/doc.dart';
import '../../providers/base.dart';
import '../base/async_values_loader.dart';

part 'two.freezed.dart';

part 'two.g.dart';

class DevelopmentTwoScreen extends HookConsumerWidget {
  const DevelopmentTwoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('Two'),
      ),
      content: AsyncValuesLoader(
        providers: [
          thingModelStreamProvider,
        ],
        child: const ThingContent(),
      ),
    );
  }
}

class ThingContent extends ConsumerWidget {
  const ThingContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thing = ref.watch(thingModelProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${thing.name}'),
        const Gap(10),
        FilledButton(
          child: const Text('Toggle name'),
          onPressed: () {
            late final String name;
            if (thing.name == null || thing.name == 'One') {
              name = 'Two';
            } else {
              name = 'One';
            }
            ref.read(thingModelProvider).updateName(name);
          },
        ),
        const Gap(10),
        FieldTextBox(),
      ],
    );
  }
}

class FieldTextBox extends StatelessWidget {
  const FieldTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormBox(
      initialValue: '',
      onFieldSubmitted: (value) => print('submitted'),
    );
  }
}

@freezed
class ThingModel with _$ThingModel implements HasDoc {
  const factory ThingModel({
    required Doc doc,
  }) = _ThingModel;

  const ThingModel._();

  String? get name => doc['name'] as String?;

  Future<void> updateName(String name) async {
    await doc.merge({'name': name});
  }
}

@Riverpod(dependencies: [firebaseServices])
Stream<ThingModel> thingModelStream(ThingModelStreamRef ref) {
  final firestore = ref.watch(firebaseServicesProvider.select((value) => value.firestore));
  return firestore.doc('development/thing').snapshots(includeMetadataChanges: true).map((event) {
    return ThingModel(doc: Doc.fromSnapshot(event, isOptional: true));
  });
}

@Riverpod(dependencies: [thingModelStream])
ThingModel thingModel(ThingModelRef ref) {
  return ref.watch(thingModelStreamProvider.select((value) => value.requireValue));
}
