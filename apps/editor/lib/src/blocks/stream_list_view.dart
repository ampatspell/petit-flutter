import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:petit_editor/src/theme.dart';

import 'separator.dart';

class StreamListView<T, I> extends HookWidget {
  final Stream<T> stream;
  final List<I> Function(T data) toList;
  final void Function(I item) onSelect;
  final Widget Function(I item) itemBuilder;

  const StreamListView({
    super.key,
    required this.stream,
    required this.toList,
    required this.onSelect,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final snapshot = useStream(stream);
    final data = snapshot.data;
    if (data != null) {
      final list = toList(data);
      if (list.isEmpty) {
        return const Center(
          child: Text('No entries'),
        );
      }
      return buildListView(list);
    } else if (snapshot.hasError) {
      return Center(
        child: Text(snapshot.error!.toString()),
      );
    } else {
      return const Center(
        child: Text('Loading…'),
      );
    }
  }

  Widget buildListView(List<I> list) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = list[index];
        return _StreamListViewItem(
          itemBuilder: itemBuilder,
          onSelect: onSelect,
          item: item,
        );
      },
      separatorBuilder: (context, index) => const Separator(),
      itemCount: list.length,
    );
  }
}

class _StreamListViewItem<I> extends HookWidget {
  final Widget Function(I item) itemBuilder;
  final void Function(I item) onSelect;
  final I item;

  const _StreamListViewItem({
    required this.itemBuilder,
    required this.onSelect,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(milliseconds: 200));
    final background = useAnimation(ColorTween(begin: AppColors.grey255, end: AppColors.grey245).animate(controller));

    return MouseRegion(
      onEnter: (e) => controller.forward(),
      onExit: (e) => controller.reverse(),
      child: GestureDetector(
        onTap: () => onSelect(item),
        child: Container(
          color: background,
          child: itemBuilder(item),
        ),
      ),
    );
  }
}

class _Pair<T> {
  final DocumentReference<T> reference;
  final T doc;

  _Pair(this.reference, this.doc);
}

class FirestoreQueryStreamListView<T> extends StatelessWidget {
  final Stream<QuerySnapshot<T>> stream;
  final void Function(DocumentReference<T> reference, T doc) onSelect;
  final Widget Function(DocumentReference<T> reference, T doc) itemBuilder;

  const FirestoreQueryStreamListView({
    super.key,
    required this.stream,
    required this.onSelect,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamListView<QuerySnapshot<T>, _Pair<T>>(
      stream: stream,
      toList: (data) => data.docs.map((e) => _Pair(e.reference, e.data())).toList(growable: false),
      onSelect: (pair) => onSelect(pair.reference, pair.doc),
      itemBuilder: (item) => itemBuilder(item.reference, item.doc),
    );
  }
}
