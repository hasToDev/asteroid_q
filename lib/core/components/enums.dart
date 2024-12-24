enum TransitionDirection {
  leftToRight('leftToRight'),
  rightToLeft('rightToLeft'),
  topToBottom('topToBottom'),
  bottomToTop('bottomToTop');

  final String getString;

  const TransitionDirection(this.getString);
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
  top(1111),
  bottom(3333),
  left(4444),
  right(2222);

  final int id;

  const NextGalaxy(this.id);
}

enum SpaceTilePosition {
  center(144),
  top(8),
  bottom(280),
  left(136),
  right(152);

  final int id;

  const SpaceTilePosition(this.id);
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

  final double angle;

  const FighterJetDirection(this.angle);
}

enum FighterJetAction {
  upgrade,
  refuel,
  shoot,
  move,
  none,
}

enum FighterJetPath {
  direct,
  transit,
}
