import 'package:flutter/animation.dart';

import '../core.dart';

class FighterJetCommand {
  final int step;
  final int index;
  final Offset offset;
  final FighterJetDirection direction;
  final FighterJetPath pathType;

  FighterJetCommand({
    required this.step,
    required this.index,
    required this.offset,
    required this.direction,
    required this.pathType,
  });

  @override
  String toString() {
    return 'FighterJetCommand {step: $step, index: $index, offset: $offset, direction: $direction, pathType: $pathType}';
  }
}
