import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:petit_zug/petit_zug.dart';

part 'sprite.g.dart';

// export const toIndex = (x, y, size) => (y * size.width) + x;
//
// export const fromIndex = (index, size) => {
// let y = Math.floor(index / size.width);
// let x = index - (y * size.width);
// return { x, y };
// }

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  String toString() {
    return 'Position{x: $x, y: $y}';
  }
}

int toIndex(int x, int y, int width) => (y * width) + x;

Position fromIndex(int index, int width) {
  final y = (index / width).floor();
  final x = index - (y * width);
  return Position(x, y);
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

  _withBytes(void Function(List<int> bytes) cb) {
    final bytes = blob.bytes.toList(growable: false);
    cb(bytes);
    data['bytes'] = Blob(Uint8List.fromList(bytes));
  }

  @action
  void fill(int value) {
    _withBytes((bytes) {
      for (int i = 0; i < bytes.length; i++) {
        bytes[i] = value;
      }
    });
  }

  @action
  void randomize() {
    _withBytes((bytes) {
      final random = Random();
      for (int i = 0; i < bytes.length; i++) {
        bytes[i] = random.nextInt(255);
      }
    });
  }

  void clear() => fill(0);
}

class Sprite extends _Sprite with _$Sprite {
  Sprite({
    required super.entity,
  });
}

abstract class _Sprite with Store {
  final SpriteEntity entity;

  _Sprite({
    required this.entity,
  });
}
