import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';

typedef OnSizeCallback = void Function(Size size);

class MeasurableWidget extends SingleChildRenderObjectWidget {
  final OnSizeCallback onSize;

  const MeasurableWidget({
    super.key,
    required super.child,
    required this.onSize,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => _MeasurableRenderObject(onSize);
}

class _MeasurableRenderObject extends RenderProxyBox {
  OnSizeCallback onSize;
  Size? _size;

  _MeasurableRenderObject(this.onSize);

  @override
  void performLayout() {
    super.performLayout();
    Size size = child!.size;
    if (_size != size) {
      _size = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onSize(size));
    }
  }
}
