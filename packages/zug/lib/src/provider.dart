part of '../zug.dart';

class MountingProvider<T extends Mountable> extends StatelessWidget {
  const MountingProvider({
    super.key,
    required this.create,
    this.lazy,
    this.builder,
    this.child,
  });

  final T Function(BuildContext context) create;
  final bool? lazy;
  final TransitionBuilder? builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Provider<T>(
      create: (context) => create(context)..mount(),
      dispose: (context, value) => value.unmount(),
      lazy: lazy,
      builder: builder,
      child: child,
    );
  }
}
