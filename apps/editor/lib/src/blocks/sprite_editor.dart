import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petit_editor/src/stores/sprite.dart';
import 'package:petit_editor/src/theme.dart';

class SpriteEditor extends StatelessWidget {
  final SpriteEntity sprite;
  final int pixel;

  const SpriteEditor({
    super.key,
    required this.sprite,
    required this.pixel,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      print('build');
      final rendered = Size((sprite.width * pixel) + 1.0, (sprite.height * pixel) + 1.0);
      return CustomPaint(
        size: rendered,
        isComplex: false,
        painter: SpritePainter(
          sprite: sprite,
          pixel: pixel,
        ),
      );
    });
  }
}

class SpritePainter extends CustomPainter {
  final SpriteEntity sprite;
  final int pixel;

  SpritePainter({
    required this.sprite,
    required this.pixel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
    paintPixels(canvas, size);
    paintWireframe(canvas, size);
  }

  void paintBackground(Canvas canvas, Size size) {
    final background = Paint()..color = AppColors.grey249;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), background);
  }

  void paintWireframe(Canvas canvas, Size size) {
    final width = sprite.width;
    final height = sprite.height;

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
    for (var x = 0; x < sprite.width; x++) {
      for (var y = 0; y < sprite.height; y++) {
        final index = toIndex(x, y, sprite.width);
        final value = sprite.blob.bytes[index];

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
    return false;
  }
}
