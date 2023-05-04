import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:petit_zug/petit_zug.dart';

part 'sprite.g.dart';

Offset offsetFromByteIndex(int index, Size size) {
  final width = size.width.toInt();
  final y = (index / width).floor();
  final x = index - (y * width);
  return Offset(x.toDouble(), y.toDouble());
}

int offsetToByteIndex(Offset offset, Size size) {
  final width = size.width.toInt();
  final height = size.height.toInt();
  final x = max(min(offset.dx.toInt(), width - 1), 0);
  final y = max(min(offset.dy.toInt(), height - 1), 0);
  return (y * width) + x;
}

class SpriteEntity extends _SpriteEntity with _$SpriteEntity {
  SpriteEntity(super.reference);

  @override
  String toString() {
    return 'Sprite{path: ${reference.path}, data: $data}';
  }
}

abstract class _SpriteEntity extends FirestoreEntity with Store {
  _SpriteEntity(super.reference);

  @computed
  int get width => data['width'];

  @computed
  int get height => data['height'];

  @computed
  Blob get blob => data['bytes'];

  @computed
  Size get size => Size(width.toDouble(), height.toDouble());

  _withBytes(bool Function(List<int> bytes) cb) {
    final bytes = blob.bytes.toList(growable: false);
    if (cb(bytes)) {
      data['bytes'] = Blob(Uint8List.fromList(bytes));
    }
  }

  int valueAtOffset(Offset offset) {
    final index = offsetToByteIndex(offset, size);
    return blob.bytes[index];
  }

  @action
  void draw(Iterable<Offset> offsets, int value) {
    _withBytes((bytes) {
      var updated = false;
      for (final offset in offsets) {
        final index = offsetToByteIndex(offset, size);
        if (bytes[index] != value) {
          bytes[index] = value;
          updated = true;
        }
      }
      return updated;
    });
  }

  @action
  void fill(int value) {
    _withBytes((bytes) {
      for (var i = 0; i < bytes.length; i++) {
        bytes[i] = value;
      }
      return true;
    });
  }

  @action
  void randomize() {
    _withBytes((bytes) {
      final random = Random();
      for (int i = 0; i < bytes.length; i++) {
        bytes[i] = random.nextInt(255);
      }
      return true;
    });
  }

  void clear() => fill(0);
}
