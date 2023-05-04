import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:petit_zug/petit_zug.dart';

part 'workspace.g.dart';

class WorkspaceEntity extends _WorkspaceEntity with _$WorkspaceEntity {
  WorkspaceEntity(super.reference);

  @override
  String toString() {
    return 'WorkspaceEntity{reference: ${reference.path}, data: $data';
  }
}

abstract class _WorkspaceEntity extends FirestoreEntity with Store {
  _WorkspaceEntity(super.reference);

  @computed
  int get pixel => data['pixel'];

  @action
  void setPixel(int pixel) {
    data['pixel'] = pixel;
  }
}

class WorkspaceNodeEntity extends _WorkspaceNodeEntity with _$WorkspaceNodeEntity {
  WorkspaceNodeEntity(super.reference);

  @computed
  int get x => data['x'];

  @computed
  int get y => data['y'];

  @computed
  int get pixel => data['pixel'];

  @computed
  String get node => data['node'];

  Offset positionForPixel(double pixel) {
    return Offset(x.toDouble(), y.toDouble()) * pixel;
  }
}

abstract class ProjectNodeEntity implements FirestoreEntity {
  Size sizeForPixel(double pixel);
}

abstract class _WorkspaceNodeEntity extends FirestoreEntity with Store {
  _WorkspaceNodeEntity(super.reference);
}

class ProjectBoxNodeEntity extends _ProjectBoxNodeEntity with _$ProjectBoxNodeEntity implements ProjectNodeEntity {
  ProjectBoxNodeEntity(super.reference);

  @override
  String toString() {
    return 'ProjectBoxNodeEntity{reference: ${reference.path}, width: $width, height: $height, color: $color}';
  }
}

abstract class _ProjectBoxNodeEntity extends FirestoreEntity with Store {
  _ProjectBoxNodeEntity(super.reference);

  @computed
  int get width => data['width'];

  @computed
  int get height => data['height'];

  @computed
  Color get color => Color(data['color'] as int);

  Size sizeForPixel(double pixel) {
    return Size(width.toDouble(), height.toDouble()) * pixel;
  }
}
