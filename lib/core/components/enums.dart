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
  top(1111, TransitionDirection.bottomToTop),
  bottom(3333, TransitionDirection.topToBottom),
  left(4444, TransitionDirection.rightToLeft),
  right(2222, TransitionDirection.leftToRight);

  final int id;
  final TransitionDirection transitionDirection;

  const NextGalaxy(this.id, this.transitionDirection);
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
  asteroidCollision,
  collisionRecover,
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

enum GameObjectType {
  asteroid,
  fuelPod,
}

enum GalaxySize {
  normal(13),
  small(9);

  final int gridSpan;

  const GalaxySize(this.gridSpan);
}
