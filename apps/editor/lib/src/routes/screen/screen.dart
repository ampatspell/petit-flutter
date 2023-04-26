import 'package:flutter/material.dart';
import 'package:petit_editor/src/get_it.dart';
import 'package:petit_editor/src/theme.dart';

import '../../blocks/separator.dart';

part 'header.dart';

class Screen extends StatelessWidget {
  final Widget body;
  final bool expandBody;
  final List<Widget>? accessories;

  const Screen({
    super.key,
    required this.body,
    this.expandBody = false,
    this.accessories,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: getItReady,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return content();
          } else if (snapshot.hasError) {
            return error(snapshot.error!);
          } else {
            return loading();
          }
        },
      ),
    );
  }

  Widget content() {
    Widget child = body;

    if (expandBody) {
      child = ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: child,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        _Header(
          accessories: accessories,
        ),
        const Separator(),
        Expanded(
          child: child,
        ),
      ],
    );
  }

  Widget error(Object error) {
    return Center(
      child: Text(error.toString()),
    );
  }

  Widget loading() {
    return const Center(
      child: Text('Loading…'),
    );
  }
}
