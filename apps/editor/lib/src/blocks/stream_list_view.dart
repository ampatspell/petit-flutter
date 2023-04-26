import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
        return InkWell(
          onTap: () => onSelect(item),
          child: itemBuilder(item),
        );
      },
      separatorBuilder: (context, index) => const Separator(),
      itemCount: list.length,
    );
  }
}
