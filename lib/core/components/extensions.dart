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
