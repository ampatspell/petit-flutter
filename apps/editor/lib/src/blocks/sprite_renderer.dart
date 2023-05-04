import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petit_editor/src/stores/sprite.dart';
import 'package:petit_editor/src/theme.dart';

class SpriteRenderer extends StatelessWidget {
  final SpriteEntity sprite;
  final int pixel;
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
      final rendered = Size((sprite.width * pixel) + addition, (sprite.height * pixel) + addition);
      final bytes = sprite.blob.bytes;
      return CustomPaint(
        size: rendered,
        isComplex: true,
        child: child,
        painter: SpritePainter(
          width: sprite.width,
          height: sprite.height,
          bytes: bytes,
          pixel: pixel,
          grid: grid,
        ),
      );
    });
  }
}

class SpritePainter extends CustomPainter {
  final int width;
  final int height;
  final Uint8List bytes;
  final int pixel;
  final bool grid;

  SpritePainter({
    required this.width,
    required this.height,
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

  void paintBackground(Canvas canvas, Size size) {
    final background = Paint()..color = AppColors.grey249;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), background);
  }

  void paintWireframe(Canvas canvas, Size size) {
    final lines = Paint()..color = Colors.black.withAlpha(20);

    for (int i = 0; i < width + 1; i++) {
      final x = (i * pixel).toDouble();
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), lines);
    }

    for (int i = 0; i < height + 1; i++) {
      final y = (i * pixel).toDouble();
      canvas.drawLine(Offset(0, y), Offset(size.width, y), lines);
    }
  }

  void paintPixels(Canvas canvas, Size size) {
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        final index = toIndex(x, y, width);
        final value = bytes[index];
        final paint = Paint()..color = Color.fromRGBO(value, value, value, 1);
        canvas.drawRect(
          Rect.fromLTWH(
            (x * pixel).toDouble(),
            (y * pixel).toDouble(),
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
