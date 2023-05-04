import 'package:fluent_ui/fluent_ui.dart';

class PixelGestureDetector extends StatelessWidget {
  final double pixel;
  final Widget? child;
  final void Function(Offset offset) onStart;
  final void Function(Offset offset) onUpdate;
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
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _onPanStart,
      onPanEnd: _onPanEnd,
      onPanUpdate: _onPanUpdate,
      child: child,
    );
  }

  Offset _toPixelOffset(Offset offset) {
    final x = (offset.dx / pixel).floorToDouble();
    final y = (offset.dy / pixel).floorToDouble();
    return Offset(x, y);
  }

  void _onPanStart(DragStartDetails details) {
    onStart(_toPixelOffset(details.localPosition));
  }

  void _onPanEnd(DragEndDetails details) {
    onEnd();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    onUpdate(_toPixelOffset(details.localPosition));
  }
}
