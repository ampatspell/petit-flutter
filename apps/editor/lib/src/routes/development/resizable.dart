import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:petit_zug/petit_zug.dart';

import '../../blocks/pixel_gesture_recognizer.dart';
import '../../blocks/resizable.dart';
import '../../blocks/sprite_renderer.dart';
import '../../blocks/with_model.dart';
import '../../get_it.dart';
import '../../stores/sprite.dart';

class DevelopmentResizableScreen extends HookWidget {
  const DevelopmentResizableScreen({super.key});

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    const id = 'box';
    final entity = useEntity(
      reference: firestore.doc('development/$id'),
      model: (reference, data) => SpriteEntity(reference),
    );

    final resize = useState(false);

    void toggleResize() {
      resize.value = !resize.value;
    }

    void reset() async {
      await entity.reference.set({
        'x': 1,
        'y': 1,
        'width': 16,
        'height': 16,
        'bytes': Blob(Uint8List(100 * 100)),
      });
    }

    const pixel = 20.0;
    final ink = useState(0);

    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Resizable'),
      ),
      content: WithLoadedModel(
        model: entity,
        onMissing: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilledButton(
                  onPressed: reset,
                  child: const Text('Create $id'),
                ),
              ],
            ),
          );
        },
        builder: (context, sprite) {
          return Container(
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilledButton(
                        child: const Text('Reset'),
                        onPressed: () => reset(),
                      ),
                      const Gap(5),
                      FilledButton(
                        child: const Text('White'),
                        onPressed: () => sprite.fill(255),
                      ),
                      const Gap(5),
                      FilledButton(
                        child: const Text('Toggle resize'),
                        onPressed: () => toggleResize(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Observer(builder: (context) {
                        final rect = sprite.rect;
                        return Positioned(
                          top: rect.top * pixel,
                          left: rect.left * pixel,
                          child: buildResizable(resize, pixel, sprite, ink),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  StatelessWidget buildResizable(
    ValueNotifier<bool> resize,
    double pixel,
    SpriteEntity sprite,
    ValueNotifier<int> ink,
  ) {
    final renderer = SpriteRenderer(
      sprite: sprite,
      pixel: pixel,
    );

    if (resize.value) {
      return Resizable(
        pixel: pixel,
        entity: sprite,
        child: renderer,
      );
    } else {
      return PixelGestureDetector(
        pixel: pixel,
        onStart: (offset) {
          ink.value = sprite.valueAtOffset(offset) > 0 ? 0 : 255;
          sprite.draw([offset], ink.value);
        },
        onUpdate: (offsets) {
          sprite.draw(offsets, ink.value);
        },
        onEnd: () {},
        child: renderer,
      );
    }
  }
}

class Red extends StatelessWidget implements WithRenderedSize {
  final double pixel;
  final HasRect entity;

  const Red({
    super.key,
    required this.entity,
    required this.pixel,
  });

  @override
  Size get renderedSize {
    final size = entity.rect.size * pixel;
    return Size(size.width + 1, size.height + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        color: Colors.red.withAlpha(20),
        width: renderedSize.width,
        height: renderedSize.height,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text('${entity.rect.size} / $renderedSize'),
        ),
      );
    });
  }
}
