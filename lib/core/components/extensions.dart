import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

extension GoRouterStateX on GoRouterState {
  TransitionDirection? get transitionDirection {
    // return extra is Map<String, dynamic>
    //     ? (extra as Map<String, dynamic>)['transitionDirection'] as TransitionDirection?
    //     : null;

    return extra is TransitionDirection ? extra as TransitionDirection : null;
  }

  GamePlayPageExtra? get gamePlayExtra {
    return extra is GamePlayPageExtra ? extra as GamePlayPageExtra : null;
  }

  WarpLoadingPageExtra? get warpExtra {
    return extra is WarpLoadingPageExtra ? extra as WarpLoadingPageExtra : null;
  }
}

extension BoxConstraintsX on BoxConstraints {
  bool isEqual(BoxConstraints constraints) => constraints.maxHeight == maxHeight && constraints.maxWidth == maxWidth;
}

extension BuildContextX on BuildContext {
  void goWithTransition(String location, {TransitionDirection? direction}) {
    // final extra = direction != null ? {'transitionDirection': direction} : null;
    // go(location, extra: extra);

    final extra = direction;
    go(location, extra: extra);
  }

  void goWarp(WarpLoadingPageExtra data) => go(AppPaths.warp, extra: data);

  void goGamePlay(GamePlayPageExtra data) => go(AppPaths.gameplay, extra: data);

  /// [style] shorten syntax for textTheme
  TextTheme get style => Theme.of(this).textTheme;
}

extension StringX on String {
  TransitionDirection get getTransitionDirection {
    switch (this) {
      case 'bottomToTop':
        return TransitionDirection.bottomToTop;
      case 'leftToRight':
        return TransitionDirection.leftToRight;
      case 'rightToLeft':
        return TransitionDirection.rightToLeft;
      case 'topToBottom':
        return TransitionDirection.topToBottom;
      default:
        return TransitionDirection.bottomToTop;
    }
  }
}

extension IntX on int {
  NextGalaxy get getNextGalaxy {
    if (this == NextGalaxy.top.id) return NextGalaxy.top;
    if (this == NextGalaxy.right.id) return NextGalaxy.right;
    if (this == NextGalaxy.bottom.id) return NextGalaxy.bottom;
    if (this == NextGalaxy.left.id) return NextGalaxy.left;
    throw ArgumentError('NextGalaxy index not exist');
  }
}

extension SpaceTilePositionX on SpaceTilePosition {
  int get id {
    int n = getIt<GameBoardProvider>().gridSize;
    switch (this) {
      case SpaceTilePosition.center:
        return ((n * n) ~/ 2);
      case SpaceTilePosition.top:
        return (n ~/ 2);
      case SpaceTilePosition.right:
        return ((n * n) ~/ 2) + (n ~/ 2);
      case SpaceTilePosition.bottom:
        return (n * (n - 1)) + (n ~/ 2);
      case SpaceTilePosition.left:
        return ((n * n) ~/ 2) - (n ~/ 2);
    }
  }
}

extension LeaderboardSorting on List<LeaderboardEntry> {
  // Sort by distance count (lowest first)
  void sortByDistance() {
    sort((a, b) => a.distance.compareTo(b.distance));
  }

  // Sort by rotate count (lowest first)
  void sortByRotate() {
    sort((a, b) => a.rotate.compareTo(b.rotate));
  }

  // Sort by refuel count (lowest first)
  void sortByRefuel() {
    sort((a, b) => a.refuel.compareTo(b.refuel));
  }

  // Sort by galaxy count (lowest first)
  void sortByGalaxy() {
    sort((a, b) => a.galaxy.compareTo(b.galaxy));
  }

  // Sort by timestamp (most recent first)
  void sortByTimestamp() {
    sort((a, b) => b.galaxy.compareTo(a.galaxy));
  }

  // Sort by multiple criteria
  void sortByAll() {
    sort((a, b) {
      // First compare by distance
      int distanceCompare = a.distance.compareTo(b.distance);
      if (distanceCompare != 0) return distanceCompare;

      // If distance is equal, compare by rotate
      int rotateCompare = a.rotate.compareTo(b.rotate);
      if (rotateCompare != 0) return rotateCompare;

      // If rotate is equal, compare by refuel
      int refuelCompare = a.refuel.compareTo(b.refuel);
      if (refuelCompare != 0) return refuelCompare;

      // If refuel is equal, compare by galaxy
      int galaxyCompare = a.galaxy.compareTo(b.galaxy);
      if (galaxyCompare != 0) return galaxyCompare;

      // If galaxy is equal, compare by timestamp (descending - most recent first)
      return b.timestamp.compareTo(a.timestamp);
    });
  }
}
