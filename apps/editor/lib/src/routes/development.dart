import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:gap/gap.dart';
import 'package:petit_editor/src/blocks/sprite_renderer.dart';
import 'package:petit_editor/src/routes/router.dart';
import 'package:petit_editor/src/stores/sprite.dart';
import 'package:petit_zug/petit_zug.dart';

import '../blocks/pixel_gesture_recognizer.dart';
import '../blocks/with_model.dart';
import '../get_it.dart';

class DevelopmentScreen extends HookWidget {
  const DevelopmentScreen({super.key});

  List<Widget> _buildItems(BuildContext context) {
    Widget item({
      IconData icon = FluentIcons.code,
      required String label,
      VoidCallback? onPressed,
    }) {
      return ListTile.selectable(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, size: 13),
              const Gap(10),
              Text(label),
            ],
          ),
        ),
        onPressed: onPressed,
      );
    }

    return [
      item(
        label: 'Sprite editor',
        onPressed: () => DevelopmentSpriteEditorRoute().go(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Development'),
      ),
      content: ListView(children: _buildItems(context)),
    );
  }
}

class DevelopmentSpriteEditorScreen extends HookWidget {
  const DevelopmentSpriteEditorScreen({super.key});

  FirebaseFirestore get firestore => it.get();

  @override
  Widget build(BuildContext context) {
    const id = 'sprite-1';
    final entity = useEntity(
      reference: firestore.doc('development/$id'),
      model: (reference) => SpriteEntity(reference),
    );

    void create() async {
      await entity.reference.set({
        'width': 32,
        'height': 16,
        'bytes': Blob(Uint8List(32 * 16)),
      });
    }

    var ink = 0;

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
                            ink = sprite.valueAtOffset(offset) > 0 ? 0 : 255;
                            sprite.draw([offset], ink);
                          },
                          onUpdate: (offsets) {
                            sprite.draw(offsets, ink);
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
