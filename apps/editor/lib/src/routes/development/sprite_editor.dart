import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:petit_zug/petit_zug.dart';

import '../../blocks/pixel_gesture_recognizer.dart';
import '../../blocks/sprite_renderer.dart';
import '../../blocks/with_model.dart';
import '../../get_it.dart';
import '../../stores/sprite.dart';

class DevelopmentSpriteEditorScreen extends HookWidget {
  const DevelopmentSpriteEditorScreen({super.key});

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    const id = 'sprite-1';
    final entity = useEntity(
      reference: firestore.doc('development/$id'),
      model: (reference, data) => SpriteEntity(reference),
    );

    final ink = useRef(0);

    void create() async {
      await entity.reference.set({
        'width': 32,
        'height': 16,
        'bytes': Blob(Uint8List(32 * 16)),
      });
    }

    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Sprite editor'),
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
                  onPressed: create,
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
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilledButton(child: const Text('Clear'), onPressed: () => sprite.fill(255)),
                      const Gap(10),
                      FilledButton(child: const Text('Random'), onPressed: () => sprite.randomize()),
                      const Gap(10),
                      FilledButton(child: const Text('Save'), onPressed: () => sprite.save()),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        child: PixelGestureDetector(
                          pixel: 20,
                          onStart: (offset) {
                            ink.value = sprite.valueAtOffset(offset) > 0 ? 0 : 255;
                            sprite.draw([offset], ink.value);
                          },
                          onUpdate: (offsets) {
                            sprite.draw(offsets, ink.value);
                          },
                          onEnd: () {},
                          child: SpriteRenderer(
                            sprite: sprite,
                            pixel: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 670,
                        child: SpriteRenderer(
                          sprite: sprite,
                          pixel: 2,
                        ),
                      ),
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
}
