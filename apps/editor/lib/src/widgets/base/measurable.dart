import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';

typedef OnSizeCallback = void Function(Size size);

class MeasurableWidget extends SingleChildRenderObjectWidget {
  const MeasurableWidget({
    super.key,
    required super.child,
    required this.onSize,
  });

  final OnSizeCallback onSize;

  @override
  RenderObject createRenderObject(BuildContext context) => _MeasurableRenderObject(onSize);
}

class _MeasurableRenderObject extends RenderProxyBox {
  _MeasurableRenderObject(this.onSize);

  OnSizeCallback onSize;
  Size? _size;

  @override
  void performLayout() {
    super.performLayout();
    final size = child!.size;
    if (_size != size) {
      _size = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onSize(size));
    }
  }
}
