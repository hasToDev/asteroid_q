enum TransitionDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

enum KeyboardAction {
  select,
  upgrade,
  refuel,
  shoot,
  move,
  none,
}

enum NextGalaxy {
  top,
  bottom,
  left,
  right,
}

enum SpaceTilePosition {
  center,
  top,
  bottom,
  left,
  right,
}

enum FighterJetDirection {
  up(0),
  upRight(45),
  right(90),
  downRight(135),
  down(180),
  downLeft(225),
  left(270),
  upLeft(315);

  final int angle;
  const FighterJetDirection(this.angle);
}

enum FighterJetAction {
  upgrade,
  refuel,
  shoot,
  move,
  rotate,
  none,
}