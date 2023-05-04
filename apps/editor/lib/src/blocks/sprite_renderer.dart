import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petit_editor/src/stores/sprite.dart';
import 'package:petit_editor/src/theme.dart';

class SpriteRenderer extends StatelessWidget {
  final SpriteEntity sprite;
  final double pixel;
  final Widget? child;

  const SpriteRenderer({
    super.key,
    required this.sprite,
    required this.pixel,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final grid = pixel > 8;
      final addition = grid ? 1.0 : 0.0;
      final rendered = (sprite.size * pixel) + Offset(addition, addition);
      final bytes = sprite.blob.bytes;
      return CustomPaint(
        size: rendered,
        isComplex: true,
        painter: SpritePainter(
          size: sprite.size,
          bytes: bytes,
          pixel: pixel,
          grid: grid,
        ),
        child: child,
      );
    });
  }
}

class SpritePainter extends CustomPainter {
  final Size size;
  final Uint8List bytes;
  final double pixel;
  final bool grid;

  SpritePainter({
    required this.size,
    required this.pixel,
    required this.bytes,
    required this.grid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
    paintPixels(canvas, size);
    if (grid) {
      paintWireframe(canvas, size);
    }
  }

  void paintBackground(Canvas canvas, Size canvasSize) {
    final background = Paint()..color = AppColors.grey249;
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height), background);
  }

  void paintWireframe(Canvas canvas, Size canvasSize) {
    final lines = Paint()..color = Colors.black.withAlpha(20);

    for (var i = 0.0; i < size.width + 1; i++) {
      final x = i * pixel;
      canvas.drawLine(Offset(x, 0), Offset(x, canvasSize.height), lines);
    }

    for (var i = 0.0; i < size.height + 1; i++) {
      final y = i * pixel;
      canvas.drawLine(Offset(0, y), Offset(canvasSize.width, y), lines);
    }
  }

  void paintPixels(Canvas canvas, Size canvasSize) {
    for (var x = 0.0; x < size.width; x++) {
      for (var y = 0.0; y < size.height; y++) {
        final index = offsetToIndex(Offset(x, y), size);
        final value = bytes[index];
        final paint = Paint()..color = Color.fromRGBO(value, value, value, 1);
        canvas.drawRect(
          Rect.fromLTWH(
            x * pixel,
            y * pixel,
            pixel.toDouble(),
            pixel.toDouble(),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant SpritePainter oldDelegate) {
    return true;
  }
}
