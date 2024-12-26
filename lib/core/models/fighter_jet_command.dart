import 'package:flutter/animation.dart';

import '../core.dart';

class FighterJetCommand {
  final int step;
  final int index;
  final Offset offset;
  FighterJetDirection direction;
  final FighterJetPath pathType;

  FighterJetCommand({
    required this.step,
    required this.index,
    required this.offset,
    required this.direction,
    required this.pathType,
  });

  void setDirectionForNextGalaxy(NextGalaxy nextGalaxy) {
    switch (nextGalaxy) {
      case NextGalaxy.top:
        direction = FighterJetDirection.up;
      case NextGalaxy.right:
        direction = FighterJetDirection.right;
      case NextGalaxy.bottom:
        direction = FighterJetDirection.down;
      case NextGalaxy.left:
        direction = FighterJetDirection.left;
    }
  }

  @override
  String toString() {
    return 'FighterJetCommand {step: $step, index: $index, offset: $offset, direction: $direction, pathType: $pathType}';
  }
}
