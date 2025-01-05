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

enum MissileAction {
  destroyAsteroid,
  move,
}

enum AsteroidDestructionType {
  fighterJet,
  missile,
}

enum GameSound {
  explosion,
  laser,
  lifeReduced,
  refuel,
  move,
}

enum GalaxySize {
  small(1, 3, 'itokawa'),
  medium(1, 5, 'hygiea'),
  large(2, 7, 'chiron');

  final int fuelPod;
  final int asteroid;
  final String apiName;

  const GalaxySize(this.fuelPod, this.asteroid, this.apiName);
}

enum TextOrientation {
  top,
  bottom,
  left,
  right,
}

enum VirtualAction {
  up,
  down,
  left,
  right,
  refuel,
  shoot,
  move,
}

enum ConfirmationDialog {
  exitGame,
  signOut,
}
