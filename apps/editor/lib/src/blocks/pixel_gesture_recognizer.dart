import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'resizable.dart';

class PixelGestureDetector extends HookWidget implements WithRenderedSize {
  final double pixel;
  final WithRenderedSize? child;
  final void Function(Offset offset) onStart;
  final void Function(Iterable<Offset> offset) onUpdate;
  final VoidCallback onEnd;

  const PixelGestureDetector({
    super.key,
    required this.pixel,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
    this.child,
  });

  @override
  Size get renderedSize => child!.renderedSize;

  @override
  Widget build(BuildContext context) {
    final previous = useRef<Offset?>(null);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (e) => _onPanStart(previous, e),
      onPanEnd: (e) => _onPanEnd(previous, e),
      onPanUpdate: (e) => _onPanUpdate(previous, e),
      child: child,
    );
  }

  Offset _toPixelOffset(Offset offset) {
    final x = (offset.dx / pixel).floorToDouble();
    final y = (offset.dy / pixel).floorToDouble();
    return Offset(x, y);
  }

  Iterable<Offset> _calculateOffsets(Offset previous, Offset current) {
    final set = <Offset>{};
    for (double p = 0.0; p < 1.0; p += 0.1) {
      final dx = previous.dx + (current.dx - previous.dx) * p;
      final dy = previous.dy + (current.dy - previous.dy) * p;
      set.add(Offset(dx.floorToDouble(), dy.floorToDouble()));
    }
    return set;
  }

  void _onPanStart(ObjectRef<Offset?> ref, DragStartDetails details) {
    final offset = _toPixelOffset(details.localPosition);
    onStart(offset);
    ref.value = offset;
  }

  void _onPanUpdate(ObjectRef<Offset?> ref, DragUpdateDetails details) {
    final offset = _toPixelOffset(details.localPosition);
    final previous = ref.value;
    if (previous != null) {
      final offsets = _calculateOffsets(previous, offset);
      onUpdate(offsets);
    } else {
      onUpdate([offset]);
    }
    ref.value = offset;
  }

  void _onPanEnd(ObjectRef<Offset?> ref, DragEndDetails details) {
    onEnd();
    ref.value = null;
  }
}
