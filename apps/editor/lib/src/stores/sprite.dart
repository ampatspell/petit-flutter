import 'dart:math';

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

  int get width => data['width'];

  int get height => data['height'];

  Blob get blob => data['bytes'];

  @action
  void fill(int value) {
    final bytes = blob.bytes;
    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = value;
    }
  }

  void randomize() {
    final random = Random();
    final bytes = blob.bytes;
    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(255);
    }
  }

  void clear() => fill(0);

  @override
  String toString() {
    return 'Sprite{path: ${reference.path}, data: $data}';
  }
}

abstract class _SpriteEntity extends FirestoreEntity with Store {
  _SpriteEntity(super.reference);
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
